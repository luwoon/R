# R

A documentation of my Psychology Undergraduate Final Year Project.

Summary of Research:
Maternal criticism is a common means by which mothers provide feedback to their children. Synchrony refers to the matching of physiological and behavioural signals between two individuals. While the impact of maternal criticism has been observed in diverse facets not limited to the affective, social cognitive, and psychological states of the child, less is understood about the impact of different types of maternal criticism. This study employed functional near-infrared spectroscopy (fNIRS) to examine adolescents’ neural responses toward 4 different types of praise and criticism from their mothers. 3 adolescents received all 4 maternal feedback conditions and the brain activities of the mother-child dyads were measured in the hyperscanning mode. 

Pre-processing of collected NIRS data on nirsLAB (NIRx Medical Technologies LLC, v2017.06, Windows 64bit):
   1. Truncate signals outside condition timeframes
   2. Inspect quality of the 20 NIRS channels, excluding noisy channels with gain setting>8 and coefficient of variation (CV) value>7.5 from further pre-processing
   3. Remove spike artefacts and replace them with the nearest signals
   4. Remove discontinuities in signals
   5. Apply band-pass frequency filter (0.1 Hz - 0.2 Hz) to signals to remove high frequency information and very low frequency information
   6. Convert signals to relative changes in HbO and HbR concentrations using the modified Beer-Lambert law

After obtaining the time-series data for each subject, they were analysed in RStudio using Dynamic Time Warping to investigate the inter-brain synchrony between the mother-child dyads.
