start mongod --dbpath .
mongodump
bsondump dump/biciklo/factures.bson > factures.json
bsondump dump/biciklo/membres.bson > membres.json
bsondump dump/biciklo/pieces.bson > pieces.json

taskkill /IM mongod.exe
