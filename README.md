# Jackett
Jackett works as a proxy server: it translates queries from apps (Sonarr, Radarr, SickRage, CouchPotato, Mylar3, Lidarr, DuckieTV, qBittorrent, Nefarious etc.) into tracker-site-specific http queries, parses the html or json response, and then sends results back to the requesting software. This allows for getting recent uploads (like RSS) and performing searches. Jackett is a single repository of maintained indexer scraping & translation logic - removing the burden from other apps.

Docker
-----------------------------------------------
This repo will periodically check Jackett for updates and build a container image from scratch using an Alpine base layout:

```
docker pull ghcr.io/elegant996/jackett:0.22.1043
```