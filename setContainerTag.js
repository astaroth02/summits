var fs = require('fs')

if (process.argv.length < 4 || process.argv.length > 6) {
	return console.log('Please provide a file name, a version and optional an architecture.\n  E. g.: node setContainerVersion.js file.yaml Ver_1.2 arm32v7');
}

var fileName = process.argv[2];
var version = process.argv[3];
var arch = process.argv[4] === undefined ? '' : process.argv[4] + '-';

fs.readFile(fileName, 'utf8', function (err, data) {
  if (err) {
    return console.log(err);
  }
  var result = data.replace(/^(\s*image:\s*[0-9a-zA-Z/._-]+)(:[0-9a-zA-Z_][0-9a-zA-Z._-]{0,127})?$/gm, '$1:' + arch + version);

  fs.writeFile(fileName, result, 'utf8', function (err) {
     if (err) {
		 return console.log(err);
	 }
  });
});