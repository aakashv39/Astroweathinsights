import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AstrotechwealthPrototypeScreen extends StatelessWidget {
  const AstrotechwealthPrototypeScreen({super.key});

  static const Color _gold = Color(0xFFD97706);
  static const Color _goldLight = Color(0xFFFBBF24);
  static const Color _goldDark = Color(0xFFB45309);
  static const Color _ink = Color(0xFF0F172A);

  @override
  Widget build(BuildContext context) {
    final bool isWide = MediaQuery.of(context).size.width >= 720;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFFBF2), Color(0xFFFFF4DE), Color(0xFFFFFBF2)],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                  child: _TopBar(ink: _ink, gold: _gold),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                  child: _Hero(isWide: isWide, ink: _ink),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                  child: _SectionTitle(
                    title: 'Services',
                    subtitle: 'Core offerings mirrored from Astrotechwealth.',
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                sliver: SliverGrid.count(
                  crossAxisCount: isWide ? 2 : 1,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: isWide ? 2.3 : 1.9,
                  children: const [
                    _FeatureCard(
                      icon: Icons.auto_graph,
                      title: 'Wealth Forecasts',
                      text:
                          'Data-backed Vedic insights for growth, cycles, and financial planning.',
                    ),
                    _FeatureCard(
                      icon: Icons.work_outline,
                      title: 'Career Direction',
                      text:
                          'Role timing, transition windows, and professional momentum guidance.',
                    ),
                    _FeatureCard(
                      icon: Icons.favorite_border,
                      title: 'Relationship Harmony',
                      text:
                          'Compatibility signals and practical alignment recommendations.',
                    ),
                    _FeatureCard(
                      icon: Icons.description_outlined,
                      title: 'Detailed Reports',
                      text:
                          'Readable, actionable report layouts designed for quick understanding.',
                    ),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                  child: _SectionTitle(
                    title: 'Pricing Snapshot',
                    subtitle: 'Prototype plans to preserve web positioning.',
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                sliver: SliverList.list(
                  children: const [
                    _PriceTile(name: 'Starter', price: 'INR 499', detail: 'Single report + summary call'),
                    _PriceTile(name: 'Growth', price: 'INR 1499', detail: 'Monthly guidance + priority insights'),
                    _PriceTile(name: 'Elite', price: 'INR 2999', detail: 'Comprehensive life and wealth planning'),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.75),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFFFFE8BA)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Prototype Note',
                          style: GoogleFonts.playfairDisplay(
                            color: _ink,
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'This Flutter app is currently aligned to Astrotechwealth visual identity only. Backend integration can be enabled later without changing this UI layer.',
                          style: GoogleFonts.nunito(
                            color: const Color(0xFF475569),
                            height: 1.45,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.ink, required this.gold});

  final Color ink;
  final Color gold;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: RichText(
            text: TextSpan(
              style: GoogleFonts.playfairDisplay(
                color: ink,
                fontSize: 28,
                fontWeight: FontWeight.w800,
              ),
              children: [
                const TextSpan(text: 'AstroTech'),
                TextSpan(
                  text: 'Wealth',
                  style: TextStyle(color: gold),
                ),
              ],
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(99),
            border: Border.all(color: const Color(0xFFFFE4B5)),
          ),
          child: Text(
            'Mobile Prototype',
            style: GoogleFonts.oswald(
              color: const Color(0xFF64748B),
              fontSize: 12,
              letterSpacing: 1,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.isWide, required this.ink});

  final bool isWide;
  final Color ink;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 22, 18, 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Color(0xFFFFF1D0)],
        ),
        border: Border.all(color: const Color(0xFFFFE3B2)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 24,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Color(0xFFFBBF24), Color(0xFFD97706)],
            ).createShader(bounds),
            child: Text(
              'Personalized Astrology Guidance',
              style: GoogleFonts.playfairDisplay(
                color: Colors.white,
                height: 1.18,
                fontWeight: FontWeight.w800,
                fontSize: isWide ? 38 : 30,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'For Wealth, Career and Life. Advanced prediction logic with timeless Vedic insight.',
            style: GoogleFonts.nunito(
              color: const Color(0xFF475569),
              fontSize: isWide ? 17 : 15,
              height: 1.45,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _GoldButton(
                  label: 'Get Started',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Prototype action: Get Started')),
                    );
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Prototype action: View Sample Report')),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: Color(0xFFD1D5DB)),
                    foregroundColor: ink,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  child: Text(
                    'View Report',
                    style: GoogleFonts.nunito(
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.playfairDisplay(
            color: const Color(0xFF0F172A),
            fontSize: 24,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: GoogleFonts.nunito(
            color: const Color(0xFF64748B),
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.text,
  });

  final IconData icon;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFFFE7C0)),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFBBF24), Color(0xFFD97706)],
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.star_rounded, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.nunito(
                    color: const Color(0xFF0F172A),
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  text,
                  style: GoogleFonts.nunito(
                    color: const Color(0xFF475569),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PriceTile extends StatelessWidget {
  const _PriceTile({
    required this.name,
    required this.price,
    required this.detail,
  });

  final String name;
  final String price;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFFE5BC)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.nunito(
                    color: const Color(0xFF0F172A),
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  detail,
                  style: GoogleFonts.nunito(
                    color: const Color(0xFF64748B),
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Text(
            price,
            style: GoogleFonts.oswald(
              color: AstrotechwealthPrototypeScreen._goldDark,
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _GoldButton extends StatelessWidget {
  const _GoldButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AstrotechwealthPrototypeScreen._goldLight,
            AstrotechwealthPrototypeScreen._gold,
          ],
        ),
        borderRadius: BorderRadius.circular(999),
        boxShadow: const [
          BoxShadow(
            color: Color(0x40D97706),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Center(
              child: Text(
                label,
                style: GoogleFonts.nunito(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}