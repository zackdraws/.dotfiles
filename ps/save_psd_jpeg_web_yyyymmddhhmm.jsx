#target photoshop

app.bringToFront();

var OUTPUT_FOLDER = "C://2026";
var JPEG_QUALITY = 12;
var WEB_QUALITY = 90;

main();

function main() {
    if (!documents.length) {
        alert("No document is open.");
        return;
    }

    var originalDoc = app.activeDocument;
    var folderPath = Folder(OUTPUT_FOLDER);
    if (!folderPath.exists) {
        alert("Output folder does not exist:\n" + folderPath.fsName);
        return;
    }

    var oldDialogs = app.displayDialogs;
    app.displayDialogs = DialogModes.NO;

    try {
        var baseName = getAvailableBaseName(folderPath, getTimestamp());
        var psdFile = File(folderPath + "/" + baseName + ".psd");
        var jpgFile = File(folderPath + "/" + baseName + ".jpg");
        var webFile = File(folderPath + "/" + baseName + "_web.jpg");

        savePhotoshop(originalDoc, psdFile);

        var exportDoc = originalDoc.duplicate(baseName + "_export", true);
        app.activeDocument = exportDoc;
        prepareJpegDocument(exportDoc);
        saveJpeg(exportDoc, jpgFile);
        saveForWeb(exportDoc, webFile);
        exportDoc.close(SaveOptions.DONOTSAVECHANGES);

        app.activeDocument = originalDoc;
        alert("Saved:\n" + psdFile.fsName + "\n" + jpgFile.fsName + "\n" + webFile.fsName);
    } catch (e) {
        try {
            app.activeDocument = originalDoc;
        } catch (ignore) {}
        alert("Save failed:\n" + e);
    } finally {
        app.displayDialogs = oldDialogs;
    }
}

function getTimestamp() {
    var now = new Date();
    return now.getFullYear().toString() +
        zeroPad(now.getMonth() + 1, 2) +
        zeroPad(now.getDate(), 2) +
        zeroPad(now.getHours(), 2) +
        zeroPad(now.getMinutes(), 2);
}

function zeroPad(n, s) {
    n = n.toString();
    while (n.length < s) n = "0" + n;
    return n;
}

function getAvailableBaseName(folderPath, baseName) {
    var testName = baseName;
    var index = 1;
    while (File(folderPath + "/" + testName + ".psd").exists ||
            File(folderPath + "/" + testName + ".jpg").exists ||
            File(folderPath + "/" + testName + "_web.jpg").exists) {
        testName = baseName + "_" + zeroPad(index, 2);
        index++;
    }
    return testName;
}

function savePhotoshop(doc, saveFile) {
    var options = new PhotoshopSaveOptions();
    options.embedColorProfile = true;
    options.alphaChannels = true;
    options.layers = true;
    doc.saveAs(saveFile, options, true, Extension.LOWERCASE);
}

function prepareJpegDocument(doc) {
    if (doc.mode !== DocumentMode.RGB) {
        doc.changeMode(ChangeMode.RGB);
    }
    if (doc.bitsPerChannel !== BitsPerChannelType.EIGHT) {
        doc.bitsPerChannel = BitsPerChannelType.EIGHT;
    }
    doc.flatten();
}

function saveJpeg(doc, saveFile) {
    var options = new JPEGSaveOptions();
    options.formatOptions = FormatOptions.OPTIMIZEDBASELINE;
    options.embedColorProfile = true;
    options.matte = MatteType.NONE;
    options.quality = JPEG_QUALITY;
    doc.saveAs(saveFile, options, true, Extension.LOWERCASE);
}

function saveForWeb(doc, saveFile) {
    var options = new ExportOptionsSaveForWeb();
    options.format = SaveDocumentType.JPEG;
    options.includeProfile = true;
    options.interlaced = false;
    options.optimized = true;
    options.quality = WEB_QUALITY;
    doc.exportDocument(saveFile, ExportType.SAVEFORWEB, options);
}
