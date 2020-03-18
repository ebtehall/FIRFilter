clc; clear;
len = 15;                                       % Length (sec)
f   = 10^4;                                     % Frequency (Hz)
fs  = 8192;                                     % Sampling Frequency (Hz)
t   = linspace(0, len, fs*len);                 % Time Vector

%Signal S(t)
signal = sin(2*pi*f*t);                         % Signal (10 kHz sine)
given_signal_axis = -fs/2: fs/(length(signal)-1): fs/2;

%Noise addition n(t)
Noise = awgn(signal, 30); 
noise_rec= Noise + signal;                      % y(t)=s(t)+n(t)

%WINDOW BASED FIR FILTER DESIGN 

%fir1 command uses a HAMMING WINDOW to design an nth-order lowpass,
%bandpass, or multiband FIR filter with linear phase.

LPF_coeff = fir1(60,[1807.9/(fs/2) 1808.1/(fs/2)]); 
%Transfer function of the filter
trans_fun = tf(LPF_coeff);

%Filtered output
output_LPF =conv(noise_rec,LPF_coeff);
output_signal_axis = -fs/2: fs/(length(output_LPF)-1): fs/2;

%Signal to noise ratio
SNR=snr(signal, noise_rec);
%Mean squared error
err = immse (signal, noise_rec);
%Power of signal
pSignal = rms(noise_rec)^2;
%power of noise signal
pnoise = rms(signal)^2;


% PLOTS

%Signal
figure; plot(t , signal); title('S(t)');
%Noise signal
figure; plot(t , noise_rec); title('y(t)=s(t)+n(t)');
%Frequency domain of signal
figure; plot(given_signal_axis , fftshift(abs(fft(signal)))); title('FFT of S(t)');
%Frequency domain of noise signal
figure; plot(given_signal_axis,  fftshift(abs(fft(noise_rec)))); title('FFT of y(t)');
%Frequency domain of filtered signal
figure; plot(output_signal_axis , fftshift(abs(fft(output_LPF)))); title('Filtered output');
%Magnitude and phase response of filter
figure; freqz(LPF_coeff);


