# R

1. A documentation of my Undergraduate Final Year Project

   Pre-processing of Near-Infrared Spectroscopy data on nirsLAB (NIRx Medical Technologies LLC, v2017.06, Windows 64bit):
      1. Truncate signals outside condition timeframes
      2. Inspect quality of the 20 NIRS channels, excluding noisy channels with gain setting > 8 and coefficient of variation (CV) value > 7.5 from further pre-                processing
      3. Replace spike artefacts with the nearest signals
      4. Remove discontinuities in signals
      5. Apply band-pass frequency filter (0.1 Hz - 0.2 Hz) to signals to remove high frequency information and very low frequency information
      6. Convert signals to relative changes in HbO and HbR concentrations using the modified Beer-Lambert law

   After obtaining the time-series data for each subject, they were analysed in RStudio using Dynamic Time Warping to investigate the inter-brain synchrony between the    dyads.
