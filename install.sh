yum install nano -y
systemctl stop firewalld
systemctl disable firewalld

apt-get update -y
sudo apt update
sudo sysctl -w net.ipv6.conf.all.disable_ipv6=1
sudo sysctl -w net.ipv6.conf.default.disable_ipv6=1
sudo sysctl -w net.ipv6.conf.lo.disable_ipv6=1
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw allow 80
sudo ufw allow 443
lam='\033[1;34m'        
tim='\033[1;35m'
wget --no-check-certificate -O Aiko-Server.sh https://raw.githubusercontent.com/AikoPanel/AikoServer/master/install.sh && bash Aiko-Server.sh


read -p " NODE ID Cổng 443: " node_id1
  [ -z "${node_id1}" ] && node_id1=0
  
read -p " NODE ID Cổng 80: " node_id2
  [ -z "${node_id2}" ] && node_id2=0

cd /etc/Aiko-Server
cat >aiko.yml <<EOF
Nodes:
  -
    PanelType: AikoPanel
    ApiConfig:
      ApiHost: https://osaka5g.com
      ApiKey: osaka009988778899
      NodeID: $node_id2
      NodeType: V2ray
      Timeout: 30
      EnableVless: false
      VlessFlow: "xtls-rprx-vision"
      RuleListPath:
    ControllerConfig:
      DisableLocalREALITYConfig: false
      EnableREALITY: false
      REALITYConfigs:
        Show: true
      CertConfig:
        CertMode: file
        CertFile: /etc/Aiko-Server/cert/aiko_server.cert
        KeyFile: /etc/Aiko-Server/cert/aiko_server.key
  -
    PanelType: AikoPanel
    ApiConfig:
      ApiHost: https://osaka5g.com
      ApiKey: osaka009988778899
      NodeID: $node_id1
      NodeType: Trojan
      Timeout: 30
      EnableVless: false
      VlessFlow: "xtls-rprx-vision"
      RuleListPath:
    ControllerConfig:
      DisableLocalREALITYConfig: false
      EnableREALITY: false
      REALITYConfigs:
        Show: true
      CertConfig:
        CertMode: file
        CertFile: /etc/Aiko-Server/cert/aiko_server.cert
        KeyFile: /etc/Aiko-Server/cert/aiko_server.key
EOF
sed -i "s|NodeID1:.*|NodeID: ${node_id1}|" ./config.yml
sed -i "s|NodeID2:.*|NodeID: ${node_id2}|" ./config.yml
cd /root
aiko-server cert
Aiko-Server restart
