function output_image = conv_colours(input_image, kernel)


output_image = zeros(size(input_image));
    for i = 1:3
       output_image(:,:,i) = conv2(input_image(:,:,i),kernel,'same');
    end
end