#!/usr/bin/env bash

fortio_ip=$(kubectl get svc client --no-headers=true | awk '{print $4}')
svc_ip=$(kubectl get svc app --namespace=service-graph --no-headers=true | awk '{print $3}')

query=$(python - <<-EOF
	import urllib

	payload = {
		'delay': '250us:30,5ms:5',
		'status': '503:0.5,429:1.5',
	}
	payload_url=urllib.urlencode(payload)

	params = {
		'labels': 'Fortio',
		'url': 'http://${svc_ip}:8080/echo?' + payload_url,
		'qps': '10000',
		't': '60s',  # timeout
		'n': '',
		'c': '32',  # threads
		'p': '50, 75, 90, 99, 99.9', #percentiles
		'r': '0.0001',
		'H': ['User-Agent: istio/fortio-1.1.0-pre', '', ''],
		'runner': 'http',
		'grpc-ping-delay': '0',
		'save': 'on',
		'load': 'Start',
	}

	query = urllib.urlencode(params, doseq=True)
	print('http://${fortio_ip}:8080/fortio/?' + query)
	EOF
)

mkdir -p tests/stress/metrics; cd tests/stress/metrics
curl -Os http://${fortio_ip}:8080/fortio/$(curl -s ${query} | awk -F "'" '/Saved/{print $2}')

