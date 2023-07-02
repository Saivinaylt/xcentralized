
locals {
  azs_count = 2
  all_azs = data.aws_availability_zones.available.names #total available zones hear 
  azs = slice(local.all_azs, 0, local.azs_count) # from that total i eleminated the last one of 3 available zones  using slice function
#   splict_value = split("-", local.azs[0]) #using splict (-) elimated the hifen symbol using splict function
  last_element = [element(split("-", local.azs[0]), length(split("-", local.azs[0]))-1), #1a finallity stored in last element using element function
                 element(split("-", local.azs[1]), length(split("-", local.azs[1]))-1)]
}