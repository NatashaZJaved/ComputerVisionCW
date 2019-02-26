Directory = strcat(pwd,'\dataset\Training\png\');

Files = dir(strcat(Directory,'*.png'));

for k = 1:length(Files)
    % Read images
    Im = imread(strcat(Directory,Files(k).name));
    Im = im2double(Im);
    
    %Make filter
    n=2;
    sigma=1;
    %We have a (2n+1)*(2n+1) filter
    G = zeros(2*n+1);
    for x = -n:n
        for y = -n:n
            G(x+n+1,y+n+1) = (1/(2*pi*sigma^2))*exp(-0.5*(x^2+y^2)/sigma^2);
        end
    end
    
    %Set range to be r. 7 is much too many - probably about 4/5 will do.
    range = 5;
    
    %Sample_size = how many pixels we are taking
    sample_size = 2;
    
    %number of rotations
    rotations = 8;
    
    curr_im = Im;
    file_name = strsplit(Files(k).name,'.');
    for j = 1:rotations
        
        %PRE-PROCESSING
        %Set background to zero
        curr_im(curr_im<1e-8) = 0;
        % Normalise
        for l=1:3
            curr_im(:,:,l) = (curr_im(:,:,l) - mean2(curr_im(:,:,l)));
            curr_im(:,:,l) = curr_im(:,:,l)/norm(curr_im(:,:,l),'fro');
        end
        %imwrite(curr_im,strcat('Templates/',file_name{1},'_rot_',num2str((j-1)*360/rotations),'_smaller_by_',num2str(sample_size^0),'_times','.png'));
        save(strcat('Templates/',file_name{1},'_rot_',num2str((j-1)*360/rotations),'_smaller_by_',num2str(sample_size^0),'_times','.mat'),'curr_im');
        for i = 1:range
            %Do convolution
            filtered = conv_colours(curr_im,G);
            
            %Do subsampling
            G_sub = filtered(1:2:size(filtered,1), 1:2:size(filtered,2),:);
            
            %Set current image to subsampled image
            curr_im = G_sub;
            
            %PRE-PROCESSING
            %Set background to zero
            curr_im(curr_im<1e-8) = 0;
            % Normalise
            for l=1:3
                curr_im(:,:,l) = (curr_im(:,:,l) - mean2(curr_im(:,:,l)));
                curr_im(:,:,l) = curr_im(:,:,l)/norm(curr_im(:,:,l),'fro');
            end
            
            save(strcat('Templates/',file_name{1},'_rot_',num2str((j-1)*360/rotations),'_smaller_by_',num2str(sample_size^i),'_times','.mat'),'curr_im');
            %imwrite(curr_im,strcat('Templates/',file_name{1},'_rot_',num2str((j-1)*360/rotations),'_smaller_by_',num2str(sample_size^i),'_times','.png'));
            
        end
        curr_im = imrotate(Im,(360/rotations)*j);
    end
    
end