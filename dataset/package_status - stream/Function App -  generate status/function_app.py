import datetime
import json
import logging
import random
import uuid
from azure.eventhub import EventHubProducerClient, EventData
import azure.functions as func
import os

EVENT_HUB_CONN_STR = os.getenv("EVENT_HUB_CONN_STR")
EVENT_HUB_NAME = "package_status"

STATUS_SEQUENCE = ["NADANA", "W DRODZE", "DO ODEBRANIA", "DORECZONA"]
MAX_PACKAGES = 8

packages = {}
packages_info = {}

app = func.FunctionApp()

@app.timer_trigger(schedule="0 */30 * * * *", arg_name="mytimer", run_on_startup=True)
def PackageStatusFunction(mytimer: func.TimerRequest) -> None:
    producer = EventHubProducerClient.from_connection_string(
        conn_str=EVENT_HUB_CONN_STR,
        eventhub_name=EVENT_HUB_NAME
    )
    event_data_batch = producer.create_batch()

    max_events = random.randint(3, 11)
    events_sent = 0  

    for pkg_id in list(packages.keys()):
        if events_sent >= max_events:
            break  

        current_index = packages[pkg_id]
        if current_index < len(STATUS_SEQUENCE) - 1:
            new_index = current_index + 1
            packages[pkg_id] = new_index
            event = {
                "package_id": pkg_id,
                "timestamp": datetime.datetime.utcnow().isoformat(),
                "status": STATUS_SEQUENCE[new_index],
                "carrier": packages_info[pkg_id]["carrier"],
            }
            event_json = json.dumps(event)
            event_data_batch.add(EventData(event_json))
            logging.info(f"Wysłano event dla paczki {pkg_id}: {event_json}")
            events_sent += 1
        else:
            logging.info(f"Paczka {pkg_id} zakończyła cykl statusów.")
            del packages[pkg_id]
            del packages_info[pkg_id]

    while events_sent < max_events and len(packages) < MAX_PACKAGES:
        pkg_id = str(uuid.uuid4())
        packages[pkg_id] = 0
        packages_info[pkg_id] = {
            "carrier": random.choice(["DHL", "InPost", "DPD", "FedEx"]),
        }
        event = {
            "package_id": pkg_id,
            "timestamp": datetime.datetime.utcnow().isoformat(),
            "status": STATUS_SEQUENCE[0],
            "carrier": packages_info[pkg_id]["carrier"],
        }
        event_json = json.dumps(event)
        event_data_batch.add(EventData(event_json))
        logging.info(f"Nadano nową paczkę {pkg_id}: {event_json}")
        events_sent += 1

    producer.send_batch(event_data_batch)
    producer.close()
