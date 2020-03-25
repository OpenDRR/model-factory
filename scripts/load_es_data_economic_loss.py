# =================================================================
#
# Authors: Tom Kralidis <tomkralidis@gmail.com>
#
# Copyright (c) 2020 Tom Kralidis
#
# Permission is hereby granted, free of charge, to any person
# obtaining a copy of this software and associated documentation
# files (the "Software"), to deal in the Software without
# restriction, including without limitation the rights to use,
# copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following
# conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
# OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
# HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
# WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.
#
# =================================================================

import json
import os
import sys

from elasticsearch import Elasticsearch
es = Elasticsearch()

if len(sys.argv) < 3:
    print('Usage: {} <path/to/data.geojson> <id-field>'.format(sys.argv[0]))
    sys.exit(1)

index_name = os.path.splitext(os.path.basename(sys.argv[1]))[0].lower()
id_field = sys.argv[2]

if es.indices.exists(index_name):
    es.indices.delete(index_name)


# index settings
settings = {
    'settings': {
        'number_of_shards': 1,
        'number_of_replicas': 1
    },
    "mappings": {
        "_meta": {
            "created_by": "load_es_data_economic_loss.py"
        },
        "properties": {
            "Sauid": {
                "type": "text",
                "fields": {
                    "keyword": {
                        "type": "keyword",
                        "ignore_above": 256
                    }
                }
            },
            "Source_Type": {
                "type": "text",
                "fields": {
                    "keyword": {
                        "type": "keyword",
                        "ignore_above": 256
                    }
                }
            },
            "Rupture_Name": {
                "type": "text",
                "fields": {
                    "keyword": {
                        "type": "keyword",
                        "ignore_above": 256
                    }
                }
            },
            "Magnitude": {
                "type": "text",
                "fields": {
                    "keyword": {
                        "type": "keyword",
                        "ignore_above": 256
                    }
                }
            },
            "Retrofit": {
                "type": "text",
                "fields": {
                    "keyword": {
                        "type": "keyword",
                        "ignore_above": 256
                    }
                }
            },
            "AssetCostT": {
                "type": "long"
            },
            "BldgCostT": {
                "type": "long"
            },
            "sL_AssetLoss": {
                "type": "float"
            },
            "sL_BldgLoss": {
                "type": "float"
            },
            "sL_ContLoss": {
                "type": "long"
            },
            "sL_LossRatio": {
                "type": "long"
            },
            "sL_NStrLoss": {
                "type": "long"
            },
            "sL_StrLoss": {
                "type": "float"
            },
            "geom_point": {
                "type": "text",
                "fields": {
                    "keyword": {
                        "type": "keyword",
                        "ignore_above": 256
                    }
                }
            }
        },
        "geometry": {
            "coordinates": {
                "type": "geo_shape"
            }
        }
    }
}


# create index
es.indices.create(index=index_name, body=settings, request_timeout=90)

with open(sys.argv[1]) as fh:
    d = json.load(fh)

for f in d['features']:
    try:
        f['properties'][id_field] = int(f['properties'][id_field])
    except ValueError:
        f['properties'][id_field] = f['properties'][id_field]
    res = es.index(index=index_name, id=f['properties'][id_field], body=f)



{'type': 'Feature', 
'properties': {
    'Sauid': '59003286', 
    'Source_Type': 'simpleFaultRupture',
     'Rupture_Name': 'SIM6p8_CR2022',
      'Magnitude': '6.8', 
      'Retrofit': 'b0', 
      'AssetCostT': '616250', 
      'BldgCostT': '425000', 
      'sL_LossRatio': '1', 
      'sL_AssetLoss': '42.9', 
      'sL_BldgLoss': '42.9', 
      'sL_StrLoss': '42.9', 
      'sL_NStrLoss': '0', 
      'sL_ContLoss': '0', 
      'geom_point': '0101000020E6100000903A112FD5C55DC074F8186A1CBC4840'
      }, 
'geometry': {
    'type': 'MultiPolygon', 
    'coordinates': [[[[-119.08981187799996, 49.46888299900012], [-119.08980550599998, 49.468835391], [-119.08958878399993, 49.46820229900005], [-119.08949436499995, 49.46805586200007], [-119.09243318899996, 49.46824363000007], [-119.09231484499996, 49.46903256900002], [-119.09242854099992, 49.4690398320001], [-119.09203516999999, 49.471662092000095], [-119.09191578599996, 49.47163979400011], [-119.09137990399992, 49.471471803000036], [-119.09070520599994, 49.471102293000094], [-119.09029713999995, 49.47071339400006], [-119.09021310899995, 49.470633290000094], [-119.08997130999995, 49.47007550600007], [-119.08990996099996, 49.46961682500007], [-119.08981187799996, 49.46888299900012]]]]
    }
}