{{$geo := split (nearby_gps 41.8028 12.4964 1000) " "}}
{"CUSTOMER_NAME": {"string":"{{name}} {{surname}}"},"PHONE_MODEL": {"string":"{{randoms "iPhone 11 Pro|Samsung Note 20|iPhone 7|Nokia 1999"}}"},"EVENT": {"string":"{{randoms "dropped|water|software failure"}}"},"STATE": {"string":"IT"},"LONG": {"double":{{index $geo 0}}},"LAT": {"double":{{index $geo 1}}}}
