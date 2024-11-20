# Pipe Network in a Nutshell

Pipe Network is a decentralized Content Delivery Network (CDN) built on the Solana blockchain, designed to enhance media streaming through a permissionless ecosystem. It allows contributors to deploy Points of Presence (PoPs) for efficient content delivery, leveraging a distributed network to reduce latency and operational costs while improving user experience.

Additonally due to their contributions, they have received $10 Million investment and has been recognized by Solana's Twittr Handle.... 

## See this for additional information

- **Get started:** [Pipe Network](https://x.com/DefiAlchemistry/status/1857659345607024843)


### How to Join

1. **Join the Pipe Network:** [Pipe Network Join Link](https://x.com/DefiAlchemistry/status/1857659345607024843)

2. Go into the screen to run 24/7 (If you are using a vps):

    ```sh
    sudo apt install screen
    screen -S pipe
    ```     
   
3. **Setup the Node:**

    ```sh
    wget -q https://raw.githubusercontent.com/Defi-Alchemist/Better-Pipe-Network-Node/refs/heads/main/pipe.sh && chmod +x pipe.sh && ./pipe.sh
    ```

4. The script will automatically load.
  
5. Add your email and password

6. The node will now connect to Pipe's servers

7. If you see your points increasing, Then its fine. Or use this command to see logs:

    ```sh
    cat node_operations.log
    ```


## Features

I’ve enhanced this node in the following ways:

- **Timeout Adjustments:** The official extension uses timeouts for node testing, which often resulted in nodes being marked offline. I’ve removed this timeout, allowing for ample testing time, so nodes always pass and you receive the highest possible points.
  
- **Extended Logging:** Additional logging has been added so you can track your current points, node testing, and heartbeats.
  
- **Persistent Session:** Unlike the official extension, a login session remains active until the user manually closes it, ensuring continuous uptime.
  
- **Regular Heartbeats & Node Testing:** Heartbeats and node testing are performed every 5 minutes. These are crucial to maintaining server awareness of your node's online status, and I’ve made sure these are always sent, even when neglected by the official extension.

- **Low Resource Usage:** Installing a headless or GUI browser on your VPS can be resource-intensive. This lightweight solution is ideal for low-end hosts, ensuring efficiency even on constrained hardware.


## Things Remaining

- **Future Updates:** I’m unsure if I’ll keep up with future updates for this node. If you’re a developer, please fork and contribute!
  
- **Mobile Support:** Running the node on mobile is a future goal (hopefully by tomorrow).


## IMPORTANT

This script has been built to help secure the Pipe Network’s decentralization. If any entity uses it for purposes like spam or airdrop farming, I will not be held responsible!
