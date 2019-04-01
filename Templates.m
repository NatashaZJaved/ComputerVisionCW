Directory = strcat(pwd,'\dataset\Training\png\');

Files = dir(strcat(Directory,'*.png'));

which_dir = 'Templates/';
dinfo = dir(which_dir);
dinfo([dinfo.isdir]) = [];   %skip directories
filenames = fullfile(which_dir, {dinfo.name});
if (~isempty(filenames))
    delete( filenames{:} )
end
%Set range to be r. 7 is much too many - probably about 4/5 will do.
%range = 8;

% Make Filter
%sigma=1;
%n=2.5*sigma;
%We have a (2n+1)*(2n+1) filter

%number of rotations
rotations = 12;

for k = 1:length(Files)
    % Read images
    Im = imread(strcat(Directory,Files(k).name));
    Im = im2double(Im);
    
    curr_im = Im;
    sub_im=curr_im;
    file_name = strsplit(Files(k).name,'.');
    for j = 1:rotations
        
        for ind = 1:length(range)
            %Do convolution
            filtered = conv_colours(curr_im,G{i});
            i = range(ind);
            %Do subsampling
            sub_im = filtered(1:i+2:size(filtered,1), 1:i+2:size(filtered,2),:);
            
            
            %PRE-PROCESSING
            %Set background to zero
            sub_im(sub_im<1e-8) = 0;
            % Normalise
            for l=1:3
                sub_im(:,:,l) = (sub_im(:,:,l) - mean2(sub_im(:,:,l)));
                sub_im(:,:,l) = sub_im(:,:,l)/norm(sub_im(:,:,l),'fro');
            end
            
            save(strcat('Templates/',file_name{1},'_smaller_by_',...
                num2str(i),'_times','_rot_',...
                num2str((j-1)*360/rotations),'.mat'),'sub_im');
            %imwrite(curr_im,strcat('Templates/',file_name{1},'_rot_',num2str((j-1)*360/rotations),'_smaller_by_',num2str(sample_size^i),'_times','.png'));
            
        end
        curr_im = imrotate(Im,(360/rotations)*j);
        sub_im=curr_im;
    end
    
end