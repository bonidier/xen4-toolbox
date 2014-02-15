here=$(dirname $0)/../
. $here/etc/config.sh
IPT=$(which iptables)
bridges_if=

# we get each bridge's name 
for brconf in $BRIDGES_CONF
do
  mybr=$(echo $brconf | awk -F'|' '{print $1}')
  bridges_if="$bridges_if $mybr"
done

# for each bridge : 
# - we allow all incoming flow, forward flow
# - we allow all outgoing flow 
for mybr in $bridges_if
do
 echo "$IPT -A INPUT -i $mybr -j ACCEPT"
 echo "$IPT -A FORWARD -i $mybr -j ACCEPT"
 echo "$IPT -A OUTPUT -o $mybr -j ACCEPT"
done
# to pass through host's gateway, we replace source IP from each bridge  to host machine's IP
echo "$IPT -t nat -A POSTROUTING -o $HOST_BRIDGE -j MASQUERADE"

#iptables -t nat -A POSTROUTING -o xbr -s 192.168.10.0/24  -j MASQUERADE
#iptables -t nat -A POSTROUTING -o xbr -s 192.168.11.0/24  -j MASQUERADE
#iptables -t nat -A POSTROUTING -o xbr -s 172.16.0.0/16 -j MASQUERADE
