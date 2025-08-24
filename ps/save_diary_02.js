#target photoshop
app.bringToFront();
main();

function main(){
    if(!documents.length) return;

    // Insert save folder path location below between quotes
    var folderPath = Folder('C://Users/zacha/desktop/2025/skb/skb_08');
    if(!folderPath.exists) {
        alert("Output folder does not exist!");
        return;
    }

    // Get current date and time
    var now = new Date();
    var year = now.getFullYear();
    var month = zeroPad(now.getMonth() + 1, 2); // Months are 0-based
    var day = zeroPad(now.getDate(), 2);
    var hour = zeroPad(now.getHours(), 2);
    var minute = zeroPad(now.getMinutes(), 2);

    var timestamp = year + month + day + hour + minute;
    var saveFile = File(folderPath + "/" + timestamp + ".psd");

    SavePhotoshop(saveFile);
};

function zeroPad(n, s) {
    n = n.toString();
    while (n.length < s) n = '0' + n;
    return n;
};

function SavePhotoshop(saveFile){
    var options = new PhotoshopSaveOptions();
    options.embedColorProfile = true;
    options.alphaChannels = true;
    options.layers = true;
    activeDocument.saveAs(saveFile, options, true, Extension.LOWERCASE);
};
#target photoshop
app.bringToFront();
main();
function main(){
if(!documents.length) return;

// insert save folder path location below between quotes

var folderPath = Folder('C://Users/zacha/desktop/2025/skb/skb_08');
if(!folderPath.exists) {
alert("Output folder does not exist!");
return;
}

//fileName should be the first part of the filename
//I.E. if you want file name = temp-0001.psd then put in "temp-"
//N.B. it must be the same case!

var fileName = "temp";
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

