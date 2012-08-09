pixie_packer_AIR
================

An AIR application to pack animation frames from a directory into a PNG 'pixie sheet' that stores header data in pixels.

To use:

Step 1.
  Place all frames of animation into one folder (PNG ONLY).
  Name frames in such a way that alphabetical order is animation order; ie. 0.png, 1.png, 2.png, 90.png, 100.png etc.

Step 2.
  Run pixie.
  It will ask for the directory of frames, point it to the folder from step 1.
  
Step 3.
  Depending on the amount of image data coming in, the program may hang while processing, this is fine.
  When the process is completed, the header data will be displayed and left open in the app window, and the app will ask you for a save location of the output file.
  
Step Final.
  Use output image as a drawable in your app with the appropriate pixie component per platform (pixie_droid, pixie_ios)