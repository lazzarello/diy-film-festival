[all:vars]
ansible_user=lazzarello

[streaming_broadcast:vars]
internal_ip=${streaming_broadcast_private}

[streaming_relay:vars]
internal_ip=${streaming_relay_private}

[streaming_broadcast]
${streaming_broadcast_public}

[streaming_relay]
${streaming_relay_public}
