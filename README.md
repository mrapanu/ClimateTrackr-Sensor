# ClimateTrackr Sensor

ClimateTrackr is a Python-based project for tracking temperature and humidity data using a DHT sensor and publishing it to RabbitMQ. This README provides an overview of the project, installation instructions, and basic usage guidelines.

## Table of Contents
- [Introduction](#Introduction)
- [Features](#Features)
- [Dependencies](#Dependencies)
- [Installation](#Installation)
- [Usage](#Usage)
- [CleanUp](#CleanUp)
- [Configuration](#Configuration)
- [Configuration-Example](#Configuration-Example)

## Introduction

ClimateTrackr is designed to monitor temperature and humidity using a DHT sensor on a Raspberry Pi or similar environment. It publishes the collected data to RabbitMQ for further processing.

## Features

- Collects temperature and humidity data using DHT sensors.
- Use Dummy Data for test/demo purposes
- Publishes data to RabbitMQ for centralized processing.
- Supports both actual sensor data and dummy data for testing.

## Dependencies

Before install anything make sure you have the following: 

- RabbitMQ Server installed and configured to receive messages from the sensor.

`IMPORTANT`: You must connect the DHT Sensor to your raspberry pi and change the `config.ini` with your configuration. See [configuration](#Configuration) section.

## Installation

To install ClimateTrackr Sensor in one command:
```
curl https://raw.githubusercontent.com/mrapanu/ClimateTrackr-Sensor/main/install.sh | bash
```

## Usage

To check the service status:
```
systemctl status climatetrackr
```

To start the service:
```
systemctl start climatetrackr
```

To stop the service:
```
systemctl stop climatetrackr
```

## CleanUp

To install ClimateTrackr Sensor write the following command:
```
bash /usr/local/bin/uninstall-climatetrackr.sh
```

## Configuration

Modify the configuration file at `/etc/climateTrackr/config.ini` to customize the settings for your environment.

| Section    | Option           | Description                                      | Default Value        |
|------------|------------------|--------------------------------------------------|----------------------|
| Logging    | log_folder       | Path to the folder for log files                 | /var/log/climateTrackr|
| Logging    | log_file         | Log file name                                    | climateTrackr.log    |
| Sensor     | room             | Room name                                        | Bedroom              |
| Sensor     | type             | Sensor type (Options: DHT11 or DHT22)            | DHT22                |
| Sensor     | pin              | Pin number for sensor                            | D3                   |
| Sensor     | dummy_data       | Enable dummy data generation (true/false)        | false                |
| RabbitMQ   | host             | RabbitMQ host address                            | localhost            |
| RabbitMQ   | port             | RabbitMQ port                                    | 5672                 |
| RabbitMQ   | username         | RabbitMQ username                                | guest                |
| RabbitMQ   | password         | RabbitMQ password                                | guest                |
| RabbitMQ   | exchange         | RabbitMQ exchange name                           | amq.direct           |
| RabbitMQ   | routing_key      | RabbitMQ routing key                             | climateTrackrKey     |
| Interval   | message_interval | Time interval between sending messages (seconds) | 120                  |

## Configuration-Example

In this example we'll do the following:

- Initialize the Raspberry Pi pin D27
- Set sensor type DHT22
- Change the room name to "Living"
- Set RabbitMQ host to 'rabbitmq-server.home.lan'
- Set RabbitMQ username / password with "testuser" / "passwd01". `IMPORTANT` make sure this user is created with this password in RabbitMQ server.
- Set RabbitMQ exchange=climatetrackr_ex and routing_key=testkey

### Wiring the Pi

Connect DHT22 sensor to the Raspberry as in the following image. This example use pin D27:

![Wiring PI with DHT22](https://github.com/mrapanu/ClimateTrackr-Sensor/blob/main/images/wiring_pi_dht22.png?raw=true)

### Change the configuration for config.ini

In this example, after the installation you have to configure the sensor as follows:
```
vi /etc/climateTrackr/config.ini
```
Change as follows:
```
room = Living
pin = D27
host = rabbitmq-server.home.lan #IP of the RabbitMQ server can be used also
username = testuser  #This user must exist on RabbitMQ
password = passwd01
exchange = climatetrackr_ex
routing_key = testkey
```
Save the file and restart climatetrackr service with:
```
systemctl restart climatetrackr
```

### RabbitMQ setup:

Login with your username / password on the RabbitMQ server. After that do the following:

1. Create an Exchange named climatetrackr_ex as follows:

![Create Exchange RMQ](https://github.com/mrapanu/ClimateTrackr-Sensor/blob/main/images/create_exchange.png?raw=true)

2. Create a queue named 'climatetrackr_queue':

![Create Queue RMQ](https://github.com/mrapanu/ClimateTrackr-Sensor/blob/main/images/create_queue.png?raw=true)

3. Select the Queue which was created and bind with the climatetrackr_ex Exchange using Routing key as testkey:

![Create Queue RMQ](https://github.com/mrapanu/ClimateTrackr-Sensor/blob/main/images/bind_queue_ex.png?raw=true)

4. Check the queue messages received from the sensor by selecting the queue and hit "Get Messages button":

![Check Messages](https://github.com/mrapanu/ClimateTrackr-Sensor/blob/main/images/get_messages.png?raw=true)