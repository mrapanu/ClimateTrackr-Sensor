import adafruit_dht
import random

def initialize_sensor(sensor_type, sensor_pin):
    if sensor_type == 'DHT11':
        return adafruit_dht.DHT11(sensor_pin)
    elif sensor_type == 'DHT22':
        return adafruit_dht.DHT22(sensor_pin)
    else:
        raise ValueError("Invalid sensor type. Supported types are 'DHT11' and 'DHT22'.")

def generate_dummy_data():
    temperature = random.randint(20, 25)
    humidity = random.randint(60, 70)
    return temperature, humidity