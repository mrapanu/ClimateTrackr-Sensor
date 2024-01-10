# ClimateTrackr Sensor

ClimateTrackr is a Python-based project for tracking temperature and humidity data using a DHT sensor and publishing it to RabbitMQ. This README provides an overview of the project, installation instructions, and basic usage guidelines.

## Table of Contents
- [Introduction](#Introduction)
- [Features](#Features)
- [Dependencies](#Dependencies)
- [Installation](#Installation)
- [Usage](#Usage)
- [CleanUp](#CleanUp)
- [Configuration](#configuration)

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

`IMPORTANT`: You must connect the DHT Sensor to your raspberry pi and change the `config.ini` with your configuration. See [configuration][#Configuration] section.

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

## Example

TO DO
