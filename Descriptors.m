function Descriptors = Descriptors(Keypoints_Oriented,Magnitude,Orientations)
% Get the 128 length descriptors for every keypoint
Descriptors = cell(size(Keypoints_Oriented));

% Loop across keypoints
% Draw Box
% Make histogram
% Store histogram

for scale = 1:size(Keypoints_Oriented,2)
    
    for blurs = 1:size(Keypoints_Oriented,1)
        
        for col = 1:3
            Descriptors{blurs,scale,col} = zeros(size(Keypoints_Oriented{blurs,scale,col},1), 128);
            
            for point = 1:size(Keypoints_Oriented{blurs,scale,col},1)
                x = Keypoints_Oriented{blurs,scale,col}(point,1);
                y = Keypoints_Oriented{blurs,scale,col}(point,2);
                
                % Create orientation and magnitude stuff. Point is at the
                % bottom right
                %box_size = 16; %16x16 grid
                x_vec = (x - 8 : x + 7) + 15;
                y_vec = (y - 8 : y + 7) + 15;
                
                point_orient = Keypoints_Oriented{blurs,scale,col}(point,3);
                
                Cur_orient_box = Orientations{blurs,scale,col}(x_vec,y_vec) - ...
                    point_orient;
                Cur_orient_box(Cur_orient_box==0) = 1;
                Cur_orient_box(Cur_orient_box<0) = Cur_orient_box(Cur_orient_box<0)+360;
                
                sigma = 8;
                G = GaussianBlurMatrix(2,sigma);
                Cur_blurred_mag_box = ...
                    filter2(G,Magnitude{blurs,scale,col}(x_vec,y_vec));
                
                cur_box = 1;
                for y_start = 1:4:13
                    for x_start = 1:4:13
                        selected_orient = Cur_orient_box(x_start:x_start+3, y_start:y_start+3);
                        selected_mag = Cur_blurred_mag_box(x_start:x_start+3, y_start:y_start+3);
                        hist = zeros(8,1);
                        which_bin = ceil(selected_orient./45);
                        for i = 1:4
                            for j = 1:4
                                hist(which_bin(i,j)) = hist(which_bin(i,j)) + selected_mag(i,j);
                            end
                        end
                        % Normalised to norm to 1
                        if (norm(hist)~=0)
                            Descriptors{blurs,scale,col}(point,(cur_box -1)*8 + 1: (cur_box -1)*8 + 8 ...
                                ) = hist./norm(hist);
                        else
                            Descriptors{blurs,scale,col}(point,(cur_box -1)*8 + 1: (cur_box -1)*8 + 8 ...
                                ) = hist;
                        end
                        cur_box = cur_box + 1;
                    end
                end
            end
        end
    end
end



end

