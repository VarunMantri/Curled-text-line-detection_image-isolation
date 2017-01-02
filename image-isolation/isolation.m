I = imread('Enter image path here');
%----------------------------------------------------------------------
% Converting image to binary format
%----------------------------------------------------------------------
I=im2bw(I,0.7);
%----------------------------------------------------------------------
% Filtering to remove the noise
%----------------------------------------------------------------------
%I=medfilt2(I,[4,4]);
%----------------------------------------------------------------------
% Complementing the image
%----------------------------------------------------------------------
I=imcomplement(I);
%----------------------------------------------------------------------
% Counting in x direction
%----------------------------------------------------------------------
siz_img=size(I);
% testing
display(siz_img(1))
display(siz_img(2))
tic
for i=1:siz_img(1)
    pix_count=0;% Initializing the counter to zero
    for h=1:siz_img(2)
        if (I(i,h)==1)
            pix_count=pix_count+1;
        end
    end
    y_cut(i)=pix_count;
end
toc
%----------------------------------------------------------------------
% Counting in y direction
%----------------------------------------------------------------------
for i=1:siz_img(2)
    pix_count=0;% Initializing the counter to zero
    for h=1:siz_img(1)
        if (I(h,i)==1)
            pix_count=pix_count+1;
        end
    end
    x_cut(i)=pix_count;
end
toc
%----------------------------------------------------------------------
% Binarizing the cuts
%----------------------------------------------------------------------
for i=1:siz_img(2)
    if (x_cut(i)<=50)
        x_cut(i)=0;
    end
    if (x_cut(i)>50)
        x_cut(i)=1;
    end
end
%----------------------------------------------------------------------
% Counting the 1's and 0's from the starting point
%----------------------------------------------------------------------
i_3=1;
pix_fg=1;
g=1;
while (pix_fg~=0)
    pix_count=0;
    if(x_cut(i_3)==1)
        display(i_3)
        pix_fg_3=1;
        h=i_3;
        while(pix_fg_3~=0)
            if(x_cut(h)==1)
                pix_count=pix_count+1;
            end
            if(x_cut(h)==0)
                pix_fg_3=0;
            end
            h=h+1;
            if(h==siz_img(2))
                pix_fg_3=0;
            end
        end
        pix_counter(g)=pix_count;
        pix_index(g)=i_3;
        pix_index_width(g)=h-1;
        g=g+1;
    end
    i_3=i_3+1;
    if(i_3==siz_img(2))
        pix_fg=0;
    end
end
i_3=i_3-1;
g=g-1;
garbage=pix_counter(1);
id1=pix_index(1);
id2=pix_index(1);
for i=2:g
   if(garbage<=pix_counter(i))
       garbage=pix_counter(i);
       id1=pix_index(i);
       id2=pix_index_width(i);
   end
end
imshow(I)
% Isolating the text region
% For the left side isolation
hold on
    x1_co=id1-10;
    y1_co=0;
    y2_co=siz_img(1);
    t=[x1_co,x1_co];
    u=[y1_co,y2_co];
    plot(t,u,'r')
hold off
% For the right side isolation
hold on
    x1_co=id2+10;
    y1_co=0;
    y2_co=siz_img(1);
    t=[x1_co,x1_co];
    u=[y1_co,y2_co];
    plot(t,u,'r')
hold off