warning off MATLAB:tifflib:TIFFReadDirectory:libraryWarning
t = Tiff('../dataset/tree.dng','r');
offsets = getTag(t,'SubIFD');
setSubDirectory(t,offsets(1));
cfa = read(t);
close(t);