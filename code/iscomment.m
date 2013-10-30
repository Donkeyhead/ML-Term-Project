function bool = iscomment(fname)

bool = 1 - isempty(strfind(fname, 'Kommentti'));

end
    