# Senior ELK Engineer – Take-Home Assignment
The assignment descriptions are in [assignment/](assignment/).

---

## Prerequisites
- Docker & Docker Compose
- Git
- (Optional) Local Java/Python/etc. if you want to simulate log generators

---

## Quick Start
1. Clone this repo
   - git clone https://github.com/your-org/senior-elk-takehome.git
   - cd senior-elk-takehome
2. Start Elastic Stack locally
    - docker-compose up -d
    - Services:
        - Elasticsearch → http://localhost:9200
        - Kibana → http://localhost:5601
        - Logstash → port 5044 (beats) / stdin (pipeline.conf)
3. Test with sample logs
    - cat logs/sample-app.json | docker exec -i elk_logstash_1 logstash -f /usr/share/logstash/pipeline/pipeline.conf

## Submitting
- Push your solution to a private GitHub repo or share as a .zip.
- Include notes in NOTES.md if needed.

Good luck 🚀