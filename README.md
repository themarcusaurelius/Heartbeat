## A Lightweight Shipper For Uptime Monitoring

Monitor services for their availability with active probing. Heartbeat is a lightweight daemon that you install on a remote server to periodically check the status of your services and determine whether they are available.

Heartbeat currently supports monitors for checking hosts via:

- ICMP (v4 and v6) Echo Requests. Use the icmp monitor when you simply want to check whether a service is available. This monitor requires root access.
- TCP. Use the tcp monitor to connect via TCP. You can optionally configure this monitor to verify the endpoint by sending and/or receiving a custom payload.
- HTTP. Use the http monitor to connect via HTTP. You can optionally configure this monitor to verify that the service returns the expected response, such as a specific status code, response header, or content.
- The tcp and http monitors both support SSL/TLS and some proxy settings.

## Installation:


#### <b>Option 1.</b> Automated Installation.

### Windows:

1) As administrator, enter the following command in Powershell or download the zip file [here](https://github.com/themarcusaurelius/Heartbeat/archive/master.zip).

```
Start-BitsTransfer -Source 'https://github.com/themarcusaurelius/Heartbeat/archive/master.zip' -Destination 'C:\Users\Administrator\Downloads\Heartbeat.zip'
```

2) Unzip the package and extract the contents to the `C:/` drive.

3) Back in Powershell, CD into the extracted folder and run the following script:

```
.\installHeartbeat.ps1
```

4) When prompted, enter your credentials below as well as the ```URL``` that you would like to monitor and click OK.

```css
Kibana URL: _PLACEHOLDER_KIBANA_URL_
Username: _PLACEHOLDER_USERNAME_
Password: _PLACEHOLDER_PASSWORD_
Elasticsearch API Endpoint: _PLACEHOLDER_API_ENDPOINT_
```

This will install and run heartbeat.

**Data should now be shipping to your Vizion Elastic app. Check the ```Discover``` tab in Kibana for the incoming logs**

<hr>

## Example Dashboard

Heartbeat comes with sample dashboards. For example:

![Imgur](https://imgur.com/ppTSCGA.png)


