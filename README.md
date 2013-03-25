SIC
===

A tiny toolbox for Still Image Coding as devised during some course work:

* color space transformation from RGB to YUV and back
* chroma sub- and upsampling 4:2:0
* bit plane coding
* Haar wavelet transform
* Daubechies wavelet transform
* 


-------

In the MatLab console run

    >> main
    
to analyze and synthesize a default image ( fault.jpg ) with 
4:2:0 subsampling, Daubechies wavelet transform and bit plane coding. 

Or run

    >> main('filename.ext')
    
to process your own image. Adapt main.m to skip parts, change the wavelet used etc.


TeuxDeux
-------
* implement zero-tree coding
* perform some analysis, e.g. PSNR, DR, average energy distribution
* 


Author
-------
Priska Herger

License
-------
