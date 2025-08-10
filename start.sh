#!/bin/bash

echo "Launching Minecraft server..."
java -jar server.jar nogui &

# Wait for Playit to initialize
echo "Waiting for Playit tunnel..."
sleep 30

# Extract tunnel IP from logs
TUNNEL_IP=$(grep -oP 'playit.gg tunnel online: \K.*' logs/latest.log | tail -1)

echo "Tunnel IP: $TUNNEL_IP"

# Send IP to Discord
if [ -n "$TUNNEL_IP" ]; then
  curl -H "Content-Type: application/json" \
       -X POST \
       -d "{\"content\": \"🟢 Minecraft server is live: $TUNNEL_IP\"}" \
       "$DISCORD_WEBHOOK"
else
  echo "❌ Could not find tunnel IP."
fi

# Wait for server to stop
wait
