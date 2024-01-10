import pika

def initialize_rabbitmq(host, port, username, password):
    connection = pika.BlockingConnection(pika.ConnectionParameters(host=host,
                                                                   port=port,
                                                                   credentials=pika.PlainCredentials(username=username,
                                                                                                     password=password)))
    channel = connection.channel()
    return connection, channel

def publish_data(channel, exchange, routing_key, body):
    channel.basic_publish(exchange=exchange,
                          routing_key=routing_key,
                          body=body,
                          properties=pika.BasicProperties(
                              delivery_mode=2,
                          ))
