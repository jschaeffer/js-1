#!/bin/sh
#set the vars
username="cvbuild@canoeventures.com@canoe_ventures:BRTvXxqF9u"
vapp=$1
#authenticate
while :;do
	xauth=`http -v --session=vapp-startup -a $username POST https://cloud.ash01.latisys.net/api/sessions 'Accept:application/*+xml;version=5.5' |grep x-vcloud-authorization|awk {'print $2'}`
	if [ -z "$xauth" ]; then
	echo "couldn't login, trying again"
	else echo $xauth; break
	fi
done
#get vapp uid
while :;do
	vappuid=`http --session=vapp-startup GET https://cloud.ash01.latisys.net/api/query?type=vApp |grep "$vapp" |awk -F 'href=' {'print$2'}|cut -d '/' -f 6|cut -d '"' -f 1`
	if [ -z "$vappuid" ]; then
        echo "couldn't get vApp ID, trying again"
        else echo $vappuid; break
        fi
done
#start it up
http --session=vapp-startup POST https://cloud.ash01.latisys.net/api/vApp/$vappuid/power/action/powerOn
#test to see if busy
while :;do
        status=`http --session=vapp-startup GET https://cloud.ash01.latisys.net/api/query?type=vApp |grep "$vapp" |awk -F 'isBusy=' {'print$2'}|cut -d '"' -f 2`
        if [[ "$status" = false ]] ; then
          echo "not busy" ; break
        else
         echo "busy right now, waiting"
         sleep 15
        fi
done
