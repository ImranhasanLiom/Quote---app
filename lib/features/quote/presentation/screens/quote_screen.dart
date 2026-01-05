import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quote_app/features/quote/domain/entities/quote_entity.dart';
import '../bloc/quote_bloc.dart';
import '../bloc/quote_event.dart';
import '../bloc/quote_state.dart';

class QuoteScreen extends StatelessWidget {
  const QuoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Trigger initial quote load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuoteBloc>().add(const GetRandomQuoteEvent());
    });

    return Scaffold(
      // Background Gradient
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF4A148C), // Colors.deepPurple.shade800 equivalent
              const Color(0xFF1A237E), // Colors.indigo.shade900 equivalent
              Colors.black,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Column(
              children: [
                // App Header
                _buildAppHeader(context),

                const SizedBox(height: 20),

                // Quote Display Section
                Expanded(
                  child: _buildQuoteSection(context),
                ),

                // Action Buttons Section
                _buildActionButtons(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ========== ১. App Header ==========
  Widget _buildAppHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // App Logo/Title
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Wisdom Quotes',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
            Text(
              'Daily inspiration at your fingertips',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: const Color(0xFFB3B3B3), // Colors.white70 equivalent
              ),
            ),
          ],
        ),

        // Stats/Info Chip
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0x1AFFFFFF), // Colors.white.withOpacity(0.1)
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0x4DFFFFFF), // Colors.white.withOpacity(0.3)
            ),
          ),
          child: BlocBuilder<QuoteBloc, QuoteState>(
            builder: (context, state) {
              final isLoaded = state is QuoteLoaded;
              return Row(
                children: [
                  Icon(
                    isLoaded ? Icons.check_circle : Icons.hourglass_empty,
                    size: 16,
                    color: isLoaded ? Colors.greenAccent : Colors.amber,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    isLoaded ? 'Loaded' : 'Loading...',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: const Color(0xFFB3B3B3), // Colors.white70
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  // ========== ২. Quote Section ==========
  Widget _buildQuoteSection(BuildContext context) {
    return BlocListener<QuoteBloc, QuoteState>(
      listener: (context, state) {
        if (state is QuoteLoaded) {
          // Success Animation
          _showSuccessToast(context);
        } else if (state is QuoteError) {
          // Error Toast
          _showErrorToast(context, state.message);
        }
      },
      child: Center(
        child: BlocBuilder<QuoteBloc, QuoteState>(
          builder: (context, state) {
            // Animation Controller for transitions
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: _buildStateContent(state, context),
            );
          },
        ),
      ),
    );
  }

  // Build content based on state
  Widget _buildStateContent(QuoteState state, BuildContext context) {
    if (state is QuoteInitial) {
      return _buildInitialDesign(context);
    } else if (state is QuoteLoading) {
      return _buildLoadingDesign();
    } else if (state is QuoteLoaded) {
      return _buildLoadedDesign(state.quote);
    } else if (state is QuoteError) {
      return _buildErrorDesign(state.message, context);
    }
    return const SizedBox();
  }

  // Initial State Design
  Widget _buildInitialDesign(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Animated Icon
        Icon(
          Icons.auto_awesome,
          size: 100,
          color: const Color(0xB3FFFFFF), // Colors.white.withOpacity(0.7)
        ),
        const SizedBox(height: 30),
        Text(
          'Ready for Inspiration?',
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            height: 1.3,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 15),
        Text(
          'Tap the button below to receive\nyour first motivational quote',
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: const Color(0xFFB3B3B3), // Colors.white70
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 30),
        // Shimmering Button
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.purpleAccent,
                Colors.blueAccent,
              ],
            ),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.purpleAccent.withAlpha(128), // 0.5 opacity = 128
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: () {
              context.read<QuoteBloc>().add(const GetRandomQuoteEvent());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.bolt, color: Colors.white),
                const SizedBox(width: 10),
                Text(
                  'GET STARTED',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Loading State Design
  Widget _buildLoadingDesign() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Animated Loading
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                Colors.purpleAccent.withAlpha(77), // 0.3 opacity = 77
                Colors.blueAccent.withAlpha(77),   // 0.3 opacity = 77
              ],
            ),
            border: Border.all(
              color: const Color(0x33FFFFFF), // Colors.white.withOpacity(0.2)
              width: 2,
            ),
          ),
          child: const Center(
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 30),
        Text(
          'Fetching Wisdom...',
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 15),
        Text(
          'Great thoughts take a moment to arrive',
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: const Color(0xFFB3B3B3), // Colors.white70
          ),
        ),
        const SizedBox(height: 10),
        // Loading dots animation
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLoadingDot(0),
            _buildLoadingDot(1),
            _buildLoadingDot(2),
          ],
        ),
      ],
    );
  }

  Widget _buildLoadingDot(int index) {
    return Container(
      width: 8,
      height: 8,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: const Color(0x80FFFFFF), // Colors.white.withOpacity(0.5)
        shape: BoxShape.circle,
      ),
    );
  }

  // Loaded State Design
  Widget _buildLoadedDesign(QuoteEntity quote) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Quote Card with Glassmorphism Effect
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: const Color(0x1AFFFFFF), // Colors.white.withOpacity(0.1)
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: const Color(0x33FFFFFF), // Colors.white.withOpacity(0.2)
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(77), // 0.3 opacity = 77
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              children: [
                // Decorative Quote Marks
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.format_quote,
                      size: 40,
                      color: const Color(0x4DFFFFFF), // Colors.white.withOpacity(0.3)
                    ),
                    Icon(
                      Icons.format_quote,
                      size: 40,
                      color: const Color(0x4DFFFFFF), // Colors.white.withOpacity(0.3)
                      textDirection: TextDirection.rtl,
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Quote Text
                Text(
                  '"${quote.content}"',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 26,
                    fontStyle: FontStyle.italic,
                    height: 1.6,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 40),

                // Author Section
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.purpleAccent.withAlpha(77), // 0.3 opacity = 77
                        Colors.blueAccent.withAlpha(77),   // 0.3 opacity = 77
                      ],
                    ),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: const Color(0x1AFFFFFF), // Colors.white.withOpacity(0.1)
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.person_outline,
                        color: const Color(0xB3FFFFFF), // Colors.white.withOpacity(0.7)
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        quote.author,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // Tags
                if (quote.tags.isNotEmpty) ...[
                  Text(
                    'Categories',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: const Color(0xFFB3B3B3), // Colors.white70
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: quote.tags.map((tag) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0x0DFFFFFF), // Colors.white.withOpacity(0.05)
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0x1AFFFFFF), // Colors.white.withOpacity(0.1)
                          ),
                        ),
                        child: Text(
                          '#$tag',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: const Color(0xFFB3B3B3), // Colors.white70
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 30),

          // Quote ID
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0x0DFFFFFF), // Colors.white.withOpacity(0.05)
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'ID: ${quote.id}',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: const Color(0x80FFFFFF), // Colors.white.withOpacity(0.5)
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Error State Design
  Widget _buildErrorDesign(String message, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Error Icon
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.red.withAlpha(26), // 0.1 opacity = 26
            border: Border.all(
              color: Colors.red.withAlpha(77), // 0.3 opacity = 77
              width: 2,
            ),
          ),
          child: Icon(
            Icons.error_outline,
            size: 50,
            color: Colors.redAccent,
          ),
        ),

        const SizedBox(height: 30),

        Text(
          'Connection Lost',
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),

        const SizedBox(height: 15),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            message,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: const Color(0xFFB3B3B3), // Colors.white70
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ),

        const SizedBox(height: 30),

        // Retry Button
        ElevatedButton(
          onPressed: () {
            context.read<QuoteBloc>().add(const RefreshQuoteEvent());
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent.withAlpha(230), // 0.9 opacity = 230
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 5,
            shadowColor: Colors.redAccent.withAlpha(128), // 0.5 opacity = 128
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.refresh, color: Colors.white),
              const SizedBox(width: 10),
              Text(
                'TRY AGAIN',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Alternative Button
        TextButton(
          onPressed: () {
            // Show offline quotes if available
          },
          child: Text(
            'View Cached Quotes',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.blueAccent,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  // ========== ৩. Action Buttons ==========
  Widget _buildActionButtons(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0x0DFFFFFF), // Colors.white.withOpacity(0.05)
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0x1AFFFFFF), // Colors.white.withOpacity(0.1)
        ),
      ),
      child: Row(
        children: [
          // Share Button


          const SizedBox(width: 15),

          // Refresh Button (Main)
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.purpleAccent,
                    Colors.blueAccent,
                  ],
                ),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.purpleAccent.withAlpha(102), // 0.4 opacity = 102
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  context.read<QuoteBloc>().add(const RefreshQuoteEvent());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.autorenew, color: Colors.white),
                    const SizedBox(width: 10),
                    Text(
                      'NEW QUOTE',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(width: 15),

          // Favorite Button

        ],
      ),
    );
  }


  // ========== ৪. Toast/Notification Methods ==========
  void _showSuccessToast(BuildContext context) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 50,
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.greenAccent.withAlpha(230), // 0.9 opacity = 230
                  Colors.tealAccent.withAlpha(230),  // 0.9 opacity = 230
                ],
              ),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.greenAccent.withAlpha(77), // 0.3 opacity = 77
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'New quote loaded successfully!',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 18, color: Colors.white),
                  onPressed: () {
                    overlayEntry.remove();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    // Auto remove after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
  }

  void _showErrorToast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: GoogleFonts.poppins(),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.redAccent,
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  // ========== ৫. Additional Features ==========



}