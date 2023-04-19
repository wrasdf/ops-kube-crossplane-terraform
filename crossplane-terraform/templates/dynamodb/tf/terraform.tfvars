name      = "<< .config.dynamodb.name >>"

hash_key  = "<< .config.dynamodb.hash_key >>"
range_key = "<< .config.dynamodb.range_key >>"

global_secondary_indexes = [
  <<- range $gsi := .config.dynamodb.global_secondary_indexes >>
  {
    "name"               = "<< $gsi.name >>"
    "hash_key"           = "<< $gsi.hash_key >>"
    "range_key"          = "<< $gsi.range_key >>"
    "write_capacity"     = << $gsi.write_capacity >>
    "read_capacity"      = << $gsi.read_capacity >>
    "projection_type"    = "<< $gsi.projection_type >>"
    "non_key_attributes" = [
      <<- range $nka := $gsi.non_key_attributes >>
      "<< $nka >>", 
      <<- end >>
    ]
  },
  <<- end >>
]

replica_regions = [
  <<- range $region := .config.dynamodb.replica_regions >>
    "<< $region >>",
  <<- end >>
]

attributes = [
  <<- range $attribute := .config.dynamodb.attributes >>
    {  
      "name" = "<< $attribute.name >>"
      "type" = "<< $attribute.type >>"
    },  
  <<- end >>
]