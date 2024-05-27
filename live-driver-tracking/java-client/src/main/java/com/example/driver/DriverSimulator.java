package com.example.driver;

import com.opencsv.CSVReader;

import java.io.FileInputStream;
import java.io.FileReader;
import java.io.IOException;
import java.util.Properties;

import org.apache.kafka.clients.producer.KafkaProducer;
import org.apache.kafka.clients.producer.Producer;
import org.apache.kafka.clients.producer.ProducerConfig;
import org.apache.kafka.clients.producer.ProducerRecord;
import org.apache.kafka.common.serialization.StringSerializer;

public class DriverSimulator {

    private Properties allProps;
    private Integer sleep;

    public static void main(String[] args) throws IOException {

        if (args.length < 1) {
            throw new IllegalArgumentException("This program takes one argument: the path to an environment configuration file.");
        }

        DriverSimulator ds = new DriverSimulator();

        String csvFile = args[0]; // Replace with your CSV file path

        ds.loadEnvProperties(args[1]);//properties
        ds.sleep(Integer.valueOf(args[2]));//sleep time between each send
        ds.start(args[0]);//csv

    }

    private void sleep(Integer sleep) {
        this.sleep = sleep;
    }

    private void start(String csvFile) {
        try (CSVReader reader = new CSVReader(new FileReader(csvFile))) {
            String[] nextLine;
            while ((nextLine = reader.readNext()) != null) {

                System.out.println(">>> " + this.allProps.get("driver.key") + ":" + nextLine[1] + "," + nextLine[0]);
                sendDataToKafka(this.allProps.get("driver.key").toString(), nextLine[1] + "," + nextLine[0]);
                Thread.sleep(sleep);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Method to send data to Kafka
    private void sendDataToKafka(String key, String value) {

        System.out.println("Sending data to Kafka: " + key + ":" + value); // Placeholder output

        // Set Kafka broker properties
        Properties properties = new Properties();
        properties.put(ProducerConfig.BOOTSTRAP_SERVERS_CONFIG, allProps.getProperty(ProducerConfig.BOOTSTRAP_SERVERS_CONFIG)); // Change to your Kafka broker

        // serializer
        properties.put(ProducerConfig.KEY_SERIALIZER_CLASS_CONFIG, StringSerializer.class.getName());
        properties.put(ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG, StringSerializer.class.getName());


        Producer<String, String> producer = new KafkaProducer<>(properties);


        String topic = allProps.getProperty("topic.name"); // Replace with your Kafka topic name


        ProducerRecord<String, String> record = new ProducerRecord<>(topic, key, value);

        // Send the message
        producer.send(record, (metadata, exception) -> {
            if (exception == null) {
                System.out.println("Message sent successfully! Metadata: " +
                        "Topic: " + metadata.topic() +
                        ", Partition: " + metadata.partition() +
                        ", Offset: " + metadata.offset());
            } else {
                System.err.println("Error while sending message: " + exception.getMessage());
            }
        });

        // Flush and close the producer
        producer.flush();
        producer.close();

    }

    public Properties loadEnvProperties(String fileName) throws IOException {
        allProps = new Properties();
        FileInputStream input = new FileInputStream(fileName);
        allProps.load(input);
        input.close();

        return allProps;
    }
}
