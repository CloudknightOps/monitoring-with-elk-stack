import json
import time
import random
from datetime import datetime, timezone

info_messages = ["created", "updated", "processed", "completed"]
error_messages = ["timeout", "failed", "connection_error", "validation_failed"]

def random_user():
    return "u{}{}{}".format(
        random.randint(1, 9),
        random.randint(1, 9),
        random.randint(1, 9)
    )

def should_generate_error():
    # ~10–11% error rate (variable each call)
    error_rate = random.uniform(0.10, 0.11)
    return random.random() < error_rate

try:
    while True:
        is_error = should_generate_error()
        level = "ERROR" if is_error else "INFO"

        # choose message according to level
        msg = random.choice(error_messages) if is_error else random.choice(info_messages)

        # realistic latency ranges (optional)
        latency_ms = random.randint(500, 2499) if is_error else random.randint(0, 799)

        entry = {
            "ts": datetime.now(timezone.utc).isoformat(timespec="seconds"),
            "svc": "payment",
            "lvl": level,
            "msg": msg,
            "user": random_user(),
            "latency_ms": latency_ms,
        }

        # defensive sanity check — ensures INFO never carries an error message
        if level == "INFO" and msg in error_messages:
            raise RuntimeError(f"Inconsistent log entry: INFO with error msg {msg!r}")

        print(json.dumps(entry))
        time.sleep(0.5)
except KeyboardInterrupt:
    print("\nStopped by user")
