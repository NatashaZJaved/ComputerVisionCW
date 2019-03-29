function output_image = filt_colours(kernel, input_image)


output_image = zeros(size(input_image));
    for i = 1:3
       output_image(:,:,i) = filter2(kernel,input_image(:,:,i));
    end
end