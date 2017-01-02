I = imread('Enter image file path here');
I=medfilt2(I,[4,4]);
I=imcrop(I,[93 59 2535 2049]);
I=imcomplement(I);
st=regionprops(I,'BoundingBox','Area');
%Ibox=reshape(s.BoundingBox);
%Ibox=reshape(Ibox,[4 num]);
imshow(I);
flag=1;
x_origin=93;
y_origin=59;
wt_timer=1;
while(flag~=0)
    
    %Computing the euclidian distances
    j=1;
    for k = 1 : length(st)
        thisBB = st(k).BoundingBox;
        thisArea=st(k).Area;
        if(thisArea>=90 && thisArea<=1200 && thisBB(2)>=y_origin && thisBB(1)>=x_origin)
            eu_dist(j)=sqrt(((thisBB(1)-x_origin)^2)+((thisBB(2)-y_origin)^2));
            eu_dist_sync(j)=k;
            j=j+1;
            %testing
            display('in here');
        end
    end
    j=j-1;
    %eu_dist_sorted=sort(eu_dist);
     %This step is transfering data into an identical array
   for i=1:j
       eu_dist_sorted(i)=eu_dist(i);
   end
   %Using the bubble sort technique
   for i=1:j-1
       for m=i+1:j
           if(eu_dist_sorted(i)>eu_dist_sorted(m))
               another_temp=eu_dist_sorted(i);
               eu_dist_sorted(i)=eu_dist_sorted(m);
               eu_dist_sorted(m)=another_temp;
           end
       end
   end
    for i=1:j
        for m=1:j
              if(eu_dist_sorted(i)==eu_dist(m))
                  eu_dist_sync_sorted(i)=eu_dist_sync(m);
              end
         end
    end
    %Computing the average character height and width
    sum_y=0;
    sum_x=0;
    for i=2:j
        temp=st(eu_dist_sync_sorted(i)).BoundingBox;
        chk=st(eu_dist_sync_sorted(i)).Area;
        if(chk<1200);
        sum_x=sum_x+temp(3);
        sum_y=sum_y+temp(4);
        end
    end
    avg_width=sum_x/(j-1);
    avg_height=sum_y/(j-1);
    %Taking the first element from the euclidian distance matrix
    %This element has the least euclidian distance
    first_element=st(eu_dist_sync_sorted(1)).BoundingBox;
    refrence_y_disp=first_element(2);
    iter=1;
    for i=1:length(st)
        a=st(i).BoundingBox;
        thisArea=st(i).Area;
        if(abs(refrence_y_disp-a(2))<1.2*avg_height && thisArea>90 && thisArea<=1200)
            line(iter)=i;
            iter=iter+1;
            refrence_y_disp=a(2);
        end
    end
    iter=iter-1;
    % raising the flag when the bottom of the page is reached
    if(iter<1)
        flag=0;
    end
    %Finding the maximum y displaced element in line vector
    variable=st(line(1)).BoundingBox;
    variable1=variable(2);
    for i=2:iter
        variable2=st(line(i)).BoundingBox;
        if(variable1<variable2(2))
            variable1=variable2(2);
        end
    end
    %testing
    display(variable1)
    
    %plotting using poly fit
    for k=1:iter-1
       tem8=st(line(k)).BoundingBox;
       t1=tem8(1);
       u1=tem8(2);
       abcd1=polyfit(t1,u1,80);
       abcde1=polyval(abcd1,t1);
       tem88=st(line(k+1)).BoundingBox;
       t2=tem88(1);
       u2=tem88(2);
       abcd2=polyfit(t2,u2,80);
       abcde2=polyval(abcd2,t2);
       t=[t1,t2];
       u=[abcde1,abcde2];
       hold on;
       plot(t,u);
       hold off;
   end
    y_origin=variable1+5;
    %Flushing away all the values
    for i=1:iter
        line(i)=0;
    end
    for i=1:j
        eu_dist(i)=0;
        eu_dist_sync(i)=0;
        eu_dist_sorted(i)=0;
        eu_dist_sync_sorted=0;
        
    end
    wt_timer=wt_timer+1;
    %testing
    display('its here')
end



