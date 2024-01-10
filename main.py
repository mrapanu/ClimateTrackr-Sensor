import os
import time
import json
from datetime import datetime
import logging
import configparser
import board 
from sensor_functions import initialize_sensor, generate_dummy_data
from rabbitmq_functions import initialize_rabbitmq, publish_data

# Set the path to the config.ini file
config_file_path = '/etc/climateTrackr/config.ini'

# Read configuration from the file
config = configparser.ConfigParser()
config.read(config_file_path)

# Set up logging folder and log file based on the config
log_folder = config.get('Logging', 'log_folder')
log_file = config.get('Logging', 'log_file')

# Create the log folder if it doesn't exist
os.makedirs(log_folder, exist_ok=True)

# Configure logging to a file
logging.basicConfig(filename=os.path.join(log_folder, log_file), level=logging.INFO)

room = config.get('Sensor', 'room')
sensor_type = config.get('Sensor', 'type')
sensor_pin = config.get('Sensor', 'pin')
dummy_data_enabled = config.getboolean('Sensor', 'dummy_data')

rabbitmq_host = config.get('RabbitMQ', 'host')
rabbitmq_port = config.getint('RabbitMQ', 'port')
rabbitmq_username = config.get('RabbitMQ', 'username')
rabbitmq_password = config.get('RabbitMQ', 'password')
exchange = config.get('RabbitMQ', 'exchange')
routing_key = config.get('RabbitMQ', 'routing_key')

# Get the message interval from config
message_interval = config.getint('Interval', 'message_interval')

# Initialize DHT sensor if dummy data is not enabled
if not dummy_data_enabled:
    dhtDevice = initialize_sensor(sensor_type, getattr(board, sensor_pin))

while True:
    try:
        if dummy_data_enabled:
            temperature, humidity = generate_dummy_data()
        else:
            temperature = dhtDevice.temperature 
            humidity = dhtDevice.humidity

        date = datetime.now()
        dt_string = date.strftime("%m/%d/%Y %H:%M:%S")
        body = json.dumps({
            "room": room,
            "date": dt_string,
            "temperature": temperature,
            "humidity": humidity
        })

        # Initialize RabbitMQ connection
        rabbitmq_connection, rabbitmq_channel = initialize_rabbitmq(rabbitmq_host, rabbitmq_port, rabbitmq_username, rabbitmq_password)

        # Publish data to RabbitMQ
        publish_data(rabbitmq_channel, exchange, routing_key, body)

    except RuntimeError as error:
        logging.error(error.args[0])
        time.sleep(2.0)
        continue

    except Exception as error:
        if not dummy_data_enabled:
            dhtDevice.exit()
        logging.error(error, exc_info=True)
        raise error

    finally:
        # Close the RabbitMQ connection
        if rabbitmq_connection and rabbitmq_connection.is_open:
            rabbitmq_connection.close()

    time.sleep(message_interval)
