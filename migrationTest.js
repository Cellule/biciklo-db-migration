var _ = require("lodash");
var fs = require("fs");
var util = require("util");


var dbExports = [
  {
    file: "./pieces.json",
    sanitize: function(row) {
      var res = /\"_id\" : ObjectId\(.*\), (.*)/.exec(row);
      return JSON.parse("{" + res[1]);
    },
    /*
    { active: boolean,
      caracteristique: string,
      nom: string,
      numero: number,
      numerobabac: string,
      prix: number, // 400c => 4.00$
      quantite: number,
      reference: string,
      remarques: string,
      section: 'string }
    */
    convert: function(piece) {
      //CALL insertItem(code,name,price,threshold,quantity);
      return util.format("CALL insertItem(%d,'%s',%d,0,%d);",
        piece.numero || 0,
        piece.nom || "",
        ((piece.prix||0)/100).toFixed(2),
        piece.quantite || 0
      );
    }
  }
]

var newData = _.map(dbExports, function(ex) {
  var file = fs.readFileSync(ex.file, {encoding: "utf8"});
  return _(file.split("\r\n"))
  .filter(function(line) {
    // filter almos empty line
    return line.length > 5;
  })
  .map(ex.sanitize || _.identity)
  .map(ex.convert)
  .value()
  .join("\n")
}).join("\n\n\n")

fs.writeFileSync("mykoopData.sql", newData);
//console.log(newItems);
