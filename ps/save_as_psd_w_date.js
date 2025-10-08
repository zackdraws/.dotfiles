#target photoshop
app.bringToFront();
main();

function main() {
    if (!documents.length) return;

    // Insert save folder path location below between quotes
    var folderPath = Folder('C://S/IPAD/');
    if (!folderPath.exists) {
        alert("Output folder does not exist!");
        return;
    }

    // Get current date and format as YYYY-MM-DD
    var now = new Date();
    var year = now.getFullYear();
    var month = zeroPad(now.getMonth() + 1, 2); // Months are 0-based
    var day = zeroPad(now.getDate(), 2);
    var fileName = year + "-" + month + "-" + day + "-";
    
    var fileType = "PSD";
    var fileList = folderPath.getFiles(fileName + "*." + fileType);
    fileList.sort().reverse();

    var newNumber = 1;
    if (fileList.length > 0) {
        var lastFile = fileList[0].toString().replace(/\....$/, '').match(/\d+$/);
        if (lastFile) {
            newNumber = Number(lastFile[0]) + 1;
        }
    }

    var saveFile = File(folderPath + "/" + fileName + zeroPad(newNumber, 4) + "." + fileType);
    SavePhotoshop(saveFile);
}

function zeroPad(n, s) {
    n = n.toString();
    while (n.length < s) n = '0' + n;
    return n;
}

function SavePhotoshop(saveFile) {
    var options = new PhotoshopSaveOptions();
    options.embedColorProfile = true;
    options.alphaChannels = true;
    options.layers = true;
    activeDocument.saveAs(saveFile, options, true, Extension.LOWERCASE);
}
