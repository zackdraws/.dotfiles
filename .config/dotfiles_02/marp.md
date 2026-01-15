---
marp: true
theme: default
style: |
  @import url('https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap');
  section {
    margin-top: 0; /* Remove default margin on top of the slide */
  }
  .bar {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100px;
    background-color: #3498db; /* Customize the color */
    z-index: 9999; /* Ensures it stays on top */
    location: top;
    width: 100%;
    height: 100px;
    background-color: #1DB954; /* Customize the color */
  }
  .header {
    background-color: #1DB954; /* Spotify green */
    color: #1DB954;
    text-align: center;
    padding: 10px 0;
    margin: 0;
    position: absolute;
    top: 0;
    width: 100%;
    z-index: 10;
  }
  .header img {
    max-width: 80px; 
    max-height: 80px;
    color:#1DB954
  }
  section h1, section h2, section h3 {
    font-family: 'Roboto', sans-serif;
    color: #1DB954; /* Spotify green */
    text-align: left; /* Align title to the left */
    position: absolute; /* Position title absolutely */
    top: 50px; /* Position title below the green banner */
    margin-left: 20px; /* Add margin from the left edge */
  }
  .right-images {
    display: flex;
    justify-content: flex-end;
    gap: 20px; /* Space between the images */
  }
  .right-images img {
    max-width: 150px;
    max-height: 150px;
  }
  .title {
    text-align: center;
    font-size: 43px;
  }
<!-- header: <div class="header"><img src="logo.png" alt="Logo" /></div> -->

<div class="title">
<div class="bar">
Title: 

---
# Welcome to Slide 1
This is the first slide of my presentation.

---

# Slide 2: Introduction
Here is some introductory content.

- Point 1
- Point 2

<div class="right-images">
  <img src="image1.png" alt="Image 1"> <!-- First local image -->
  <img src="image2.png" alt="Image 2"> <!-- Second local image -->
</div>

---

# Slide 3: Key Concepts
Here are the key concepts I want to cover.

1. Concept 1
2. Concept 2

<div class="right-images">
  <img src="image1.png" alt="Image 1"> <!-- First local image -->
  <img src="image2.png" alt="Image 2"> <!-- Second local image -->
</div>

---

# Slide 4: Conclusion
Thank you for your attention!
