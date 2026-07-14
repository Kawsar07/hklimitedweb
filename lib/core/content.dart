/// All site copy lives here, so updating a sentence never means hunting
/// through widget files.
class Company {
  Company._();

  static const String name = 'Solar PV HK Limited';
  static const String shortName = 'Solar PV HK';
  static const String tagline =
      'Global solar sourcing, delivered to Bangladesh and beyond.';
  static const String hq = 'Hong Kong';
  static const String registeredAddress =
      "Unit 909, Prosperity Millennia Plaza, 663 King's Road, "
      'Quarry Bay, Hong Kong';
  static const String founded = '2026';
  static const String phone = '+852-61880715';
  static const String email = 'info@solarpvhk.com';
  static const String website = 'www.solarpvhk.com';
  static const String logoAsset = 'assets/images/logo-icon-only.png';

  /// Where "Send Message" on the Contact page actually delivers to.
  static const String contactRecipient = 'kawsar@scube.com.bd';

  /// Free access key from https://web3forms.com — sign up with
  /// [contactRecipient] as the receiving email, then paste the key here.
  ///
  /// This is required for the contact form to actually deliver messages.
  /// Until it is set, the form falls back to opening a pre-filled mailto:
  /// draft — which does nothing on most visitors' browsers/phones because
  /// they have no default mail app configured, so nothing appears to send.
  static const String web3FormsAccessKey = 'YOUR_WEB3FORMS_ACCESS_KEY';

  static const String heroSubhead =
      'We source renewable energy hardware directly from trusted '
      'manufacturers in China, Germany and the Netherlands, and make it '
      'reliably available to installers, EPC companies and retailers in '
      'Bangladesh — with the same sourcing network built to grow further.';

  static const String aboutIntro =
      'Solar PV HK Limited is a Hong Kong-based company launching in $founded '
      'with one goal: make sourcing solar and renewable energy hardware '
      'simple. Reliable, good-quality solar equipment is still hard to find '
      'in many growing markets. We close that gap by working directly with '
      'trusted manufacturers worldwide and putting their products within '
      'easy reach of customers in Bangladesh and beyond.';

  static const String mission =
      'Make renewable energy hardware sourcing simpler and more accessible, '
      'by connecting trusted overseas manufacturers directly with '
      'installers, EPC companies and retailers who need reliable supply.';

  static const String vision =
      'To become the most trusted sourcing partner for solar and '
      'renewable energy hardware in Bangladesh, and a dependable bridge '
      'between global manufacturers and South Asia\u2019s growing clean '
      'energy market.';

  static const List<String> businessModel = [
    'Source renewable energy products and accessories directly from '
        'manufacturers in China, Germany, the Netherlands and other countries.',
    'Make renewable energy hardware sourcing simpler and more accessible '
        'for customers through a single, reliable point of contact.',
    'Distribute and supply to Bangladesh, expanding to other countries as '
        'the network grows.',
    'Position the brand as a reliable, trusted supplier for solar '
        'hardware and accessories.',
    'Build long-term relationships with overseas manufacturers for '
        'consistent supply and competitive pricing.',
  ];

  static const List<ProductCategory> products = [
    ProductCategory(
      title: 'Solar Inverters',
      detail: 'On-grid, off-grid and hybrid inverters for residential, '
          'commercial and industrial installations.',
      icon: 'inverter',
    ),
    ProductCategory(
      title: 'Tier 1 Solar Panels',
      detail: 'Tier 1 monocrystalline modules across a range of wattages, '
          'sourced from established manufacturers.',
      icon: 'panel',
    ),
    ProductCategory(
      title: 'Solar Mounting Structures',
      detail: 'Roof-top and ground-mount structures engineered for '
          'regional wind and load conditions.',
      icon: 'mount',
    ),
    ProductCategory(
      title: 'DC Cables & Connectors',
      detail: 'Solar-grade DC cables and MC4 connectors built for '
          'outdoor durability.',
      icon: 'cable',
    ),
    ProductCategory(
      title: 'Other Accessories',
      detail: 'Combiner boxes, circuit breakers, monitoring devices and '
          'related balance-of-system components.',
      icon: 'accessory',
    ),
  ];

  static const List<SourcingCountry> sourcingCountries = [
    SourcingCountry(
      country: 'China',
      detail: 'Cost-effective, high-volume solar panels, inverters, '
          'mounting structures and accessories.',
    ),
    SourcingCountry(
      country: 'Germany',
      detail: 'Premium-quality inverters and engineering-grade '
          'components.',
    ),
    SourcingCountry(
      country: 'Netherlands',
      detail: 'Specialised accessories and cabling solutions.',
    ),
    SourcingCountry(
      country: 'Expanding network',
      detail: 'New sourcing countries added as reliable manufacturers '
          'are identified.',
    ),
  ];

  static const List<String> whyChooseUs = [
    'Direct manufacturer relationships — fewer middlemen, more consistent '
        'pricing and supply.',
    'Multi-country sourcing across China, Germany and the Netherlands, so '
        'you are never dependent on a single market.',
    'A single, reliable point of contact for installers, EPC companies '
        'and retailers in Bangladesh.',
    'Product range built around what regional projects actually need: '
        'inverters, panels, structures, cabling and accessories.',
    'A growing network, built from day one to extend beyond Bangladesh '
        'as demand grows.',
  ];

  static const List<StatItem> stats = [
    StatItem(value: founded, label: 'Founded'),
    StatItem(value: '3+', label: 'Sourcing countries'),
    StatItem(value: '5', label: 'Product categories'),
    StatItem(value: 'HK \u2192 BD', label: 'Primary trade route'),
  ];

  static const List<NavItem> navItems = [
    NavItem(label: 'Home', path: '/home'),
    NavItem(label: 'About', path: '/about'),
    NavItem(label: 'Products', path: '/products'),
    NavItem(label: 'Why Us', path: '/why-us'),
    NavItem(label: 'Contact', path: '/contact'),
  ];
}

class ProductCategory {
  final String title;
  final String detail;
  final String icon;
  const ProductCategory({
    required this.title,
    required this.detail,
    required this.icon,
  });
}

class SourcingCountry {
  final String country;
  final String detail;
  const SourcingCountry({required this.country, required this.detail});
}

class StatItem {
  final String value;
  final String label;
  const StatItem({required this.value, required this.label});
}

class NavItem {
  final String label;
  final String path;
  const NavItem({required this.label, required this.path});
}
