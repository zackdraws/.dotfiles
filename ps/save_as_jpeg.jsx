#target photoshop
var prefix = "_";
var docName = activeDocument.name.replace(/\.[^\.]+$/, '');
var saveFile = new File(activeDocument.path + "/" + prefix + docName);

var qlty = 12; //set jpeg quality here
var jpgFile = new File(saveFile);
jpgSaveOptions = new JPEGSaveOptions();
jpgSaveOptions.formatOptions = FormatOptions.OPTIMIZEDBASELINE;
jpgSaveOptions.embedColorProfile = true;
jpgSaveOptions.matte = MatteType.NONE;
jpgSaveOptions.quality = qlty;

activeDocument.saveAs(jpgFile, jpgSaveOptions, true, Extension.LOWERCASE);
