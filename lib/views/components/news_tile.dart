import 'package:cached_network_image/cached_network_image.dart';
import 'package:eigital_sample_app/views/res/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsTile extends StatelessWidget {
  final String? title;
  final String? name;
  final String? description;
  final String? publishedAt;
  final String? urlToImage;
  final String? author;
  final String? url;

  const NewsTile(
      {Key? key,
      this.title,
      this.url,
      this.author,
      this.name,
      this.description,
      this.publishedAt,
      this.urlToImage})
      : super(key: key);

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url,
          forceSafariVC: true, forceWebView: true, enableJavaScript: true);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(7)),
        ),
        child: Column(
          children: [
            _buildNewsImage(context),
            _buildNewsMiddle(),
            const Divider(),
            _buildNewsBottom(),
          ],
        ),
      ),
    );
  }

  Widget _buildNewsMiddle() {
    var unescape = HtmlUnescape();
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              _launchURL(url!);
            },
            child: Text(
              title!,
              style: kSubtitle18TextStyle,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(unescape.convert(description!), style: kCaption12TextStyle),
        ],
      ),
    );
  }

  Widget _buildNewsImage(BuildContext context) {
    return urlToImage!.isNotEmpty
        ? ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(7),
              topRight: Radius.circular(7),
            ),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 150,
              child: CachedNetworkImage(
                fit: BoxFit.fitWidth,
                errorWidget: (context, url, error) => const Center(
                  child: Icon(Icons.link_off, color: Colors.white60),
                ),
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
                imageUrl: urlToImage!,
              ),
            ),
          )
        : ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(7),
              topRight: Radius.circular(7),
            ),
            child: Container(
              height: 150.0,
              child: const Center(child: FlutterLogo()),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(7),
                  topRight: Radius.circular(7),
                ),
              ),
            ),
          );
  }

  Widget _buildNewsBottom() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Flexible(
                      fit: FlexFit.loose,
                      child: Text(name!,
                          softWrap: false, overflow: TextOverflow.fade),
                    ),
                    Flexible(
                      fit: FlexFit.loose,
                      child: Text('  \u2022  $publishedAt',
                          softWrap: false, overflow: TextOverflow.fade),
                    ),
                  ],
                ),
                author!.isNotEmpty
                    ? Text(author!, overflow: TextOverflow.ellipsis)
                    : Container()
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Share.share('$title\n\n$url', subject: title);
            },
            child: const Icon(
              Icons.share,
              size: 25,
            ),
          ),
        ],
      ),
    );
  }
}
