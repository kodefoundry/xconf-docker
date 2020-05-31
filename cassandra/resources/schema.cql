CREATE KEYSPACE "ApplicationsDiscoveryDataService" WITH replication = {
'class': 'SimpleStrategy',
'replication_factor': '3'
};