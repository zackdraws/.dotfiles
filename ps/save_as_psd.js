#target photoshop
app.bringToFront();
main();
function main(){
if(!documents.length) return;

// insert save folder path location below between quotes

var folderPath = Folder('C://S/IPAD/');
if(!folderPath.exists) {
alert("Output folder does not exist!");
return;
}

//fileName should be the first part of the filename
//I.E. if you want file name = temp-0001.psd then put in "temp-"
//N.B. it must be the same case!

var fileName = "temp-";
var fileType = "PSD";
var fileList = new Array();
var newNumber=0;
var saveFile='';
fileList = folderPath.getFiles((fileName + "*." + fileType));
fileList.sort().reverse();
if(fileList.length == 0){
saveFile=File(folderPath + "/" + fileName + "0001." +fileType);
SavePhotoshop(saveFile);
}else{
newNumber = Number(fileList[0].toString().replace(/\....$/,'').match(/\d+$/)) +1;
saveFile=File(folderPath + "/" + fileName + zeroPad(newNumber, 4) + "." +fileType);
SavePhotoshop(saveFile);
}
};
function zeroPad(n, s) {
n = n.toString();
while (n.length < s) n = '0' + n;
return n;
};
function SavePhotoshop(saveFile){
PhotoshopSaveOptions = new PhotoshopSaveOptions();
PhotoshopSaveOptions.embedColorProfile = true;
PhotoshopSaveOptions.alphaChannels = true;
PhotoshopSaveOptions.layers = true;
activeDocument.saveAs(saveFile, PhotoshopSaveOptions, true, Extension.LOWERCASE);
};
