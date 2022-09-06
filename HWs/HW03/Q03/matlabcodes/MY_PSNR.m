function output = MY_PSNR(I_1,I_2)
output = 10*log10(1/MY_MSE(I_1,I_2));
end