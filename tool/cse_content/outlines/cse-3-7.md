# Course: Signals & Systems  (level id "deep-cse-3-7", lesson ids "deep-cse-3-7-01".."-25")
Builds on Calculus (deep-cse-1-4), Electrical Circuits (deep-cse-1-5: RC circuits) and Math III (deep-cse-2-7: complex numbers,
Euler's formula, Fourier series/transform maths, Laplace maths). Those are only recapped; here the focus is the engineering view:
what a signal is, what a system does to it, LTI systems, convolution, spectra, sampling, and the Laplace/Z tools used to analyse
real systems. Deep DFT/FFT and filter design are left to Digital Signal Processing (deep-cse-5-7); modulation details to
Data Communication (deep-cse-3-6). Every idea is shown with small numbers worked step by step.
01 What signals and systems are: signal = quantity changing with time/space, system = box that changes a signal, examples (voice, ECG, stock price, image), input-output picture, where the course is used (audio, phones, control, ML), course map
02 Continuous-time vs discrete-time, analog vs digital: x(t) vs x[n], sampling as taking samples, quantization, why computers need discrete digital signals, notation, plotting stems
03 Classifying signals: deterministic vs random, periodic vs aperiodic (fundamental period, sum of periodic signals, DT periodicity rule), even and odd parts, causal/anti-causal, energy and power signals with worked examples
04 Operations on the time axis: time shift, time reversal, time scaling (CT and DT decimation/expansion), combined operations in the right order, amplitude scaling, addition, multiplication, worked sketches
05 Elementary signals: unit step, unit impulse (CT delta, DT delta), sifting property, ramp, rectangular pulse, real and complex exponentials, sinusoids, relations between step/impulse/ramp, DT sinusoid frequency only up to 2π
06 System properties: memory/memoryless, causality, linearity (additivity + homogeneity), time invariance, BIBO stability, invertibility, testing each on example systems
07 Interconnecting and describing systems: series, parallel, feedback, block diagrams with adder/multiplier/delay, input-output equations, why LTI is the star of the course
08 LTI systems and impulse response: any DT signal as a sum of shifted impulses, superposition, h[n] describes the whole system, deriving the convolution sum
09 Convolution sum worked: flip-and-slide method, table method, length of output, finite sequences, moving average and echo examples
10 Convolution integral (CT): derivation idea, graphical method, rectangle with rectangle (triangle), exponential input to RC-like system, step response
11 Properties of convolution and LTI systems: commutative, associative, distributive, identity, causality from h, stability from absolute sum/integral, step response as running sum/integral, FIR vs IIR
12 Differential and difference equation systems: linear constant-coefficient equations, recursive vs non-recursive, initial rest, solving a first-order difference equation by iteration, direct form block diagrams
13 Fourier series of CT periodic signals (signals view): complex exponentials as eigenfunctions of LTI systems, harmonics, spectrum lines, square wave spectrum, what an LTI system does to each harmonic
14 Discrete-time Fourier series: N-periodic sequences, only N distinct harmonics, computing coefficients for a small N worked, link to DFT (pointer to DSP)
15 Continuous-time Fourier transform (signals view): from series to transform, spectrum of a pulse (sinc), bandwidth, key pairs, time-frequency trade-off
16 Fourier transform properties in action: linearity, time shift (phase), scaling, convolution becomes multiplication, multiplication becomes convolution, Parseval energy, duality idea
17 Discrete-time Fourier transform (DTFT): definition, periodic in ω with period 2π, low vs high frequency in DT, DTFT of a pulse and of a^n u[n], convolution property
18 Frequency response and filters: H(jω) and H(e^jω), magnitude and phase, ideal low/high/band-pass/band-stop, why ideal is impossible (non-causal), simple RC low-pass and moving average, decibels, linear phase idea
19 Sampling theorem: sampling as multiplication by impulse train, spectrum copies, Nyquist rate, aliasing (wagon wheel, 44.1 kHz audio), anti-aliasing filter, reconstruction, zero-order hold
20 Modulation as a signals idea: multiplying by a cosine shifts the spectrum, AM and DSB-SC, synchronous demodulation, frequency-division multiplexing (radio stations), pointer to Data Communication
21 Laplace transform for systems: s = σ + jω, bilateral vs unilateral, region of convergence, poles and zeros, s-plane plot, link to Fourier (jω axis)
22 Transfer function and stability with Laplace: H(s) from a differential equation, poles in left half-plane, causality and ROC, first and second order systems, step response, RLC example
23 Z-transform: definition, z = re^jω, ROC, common pairs (δ, u, a^n u), properties (linearity, shift = multiply by z^-1, convolution), relation to DTFT on the unit circle
24 Inverse Z-transform and DT system analysis: partial fractions, long division, H(z) from difference equation, poles inside unit circle for stability, solving a difference equation, FIR vs IIR in z
25 Correlation, spectra and wrap-up: cross- and auto-correlation (radar, finding a signal in noise), energy/power spectral density idea, noise, real applications (audio, image, communication, control, ML), course recap, what next (DSP, communication, control)
