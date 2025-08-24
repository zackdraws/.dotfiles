#target photoshop
app.bringToFront();
main();

function main(){
    // Set dimensions for 16:9 aspect ratio at 300 DPI
    // Example size: 4800 x 2700 pixels (16 inches x 9 inches at 300 DPI)
    var widthInInches = 16;
    var heightInInches = 9;
    var resolution = 300; // DPI

    var widthInPixels = widthInInches * resolution;
    var heightInPixels = heightInInches * resolution;

    var docName = "16x9_300dpi";

    // Create the new document
    var newDoc = app.documents.add(
        widthInPixels,
        heightInPixels,
        resolution,
        docName,
        NewDocumentMode.RGB,
        DocumentFill.WHITE
    );

    // The new document is opened automatically
}
