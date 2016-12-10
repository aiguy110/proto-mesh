sudo batctl o -H | wc -l | awk '{print expr $1 + 1}'
