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
    var unescape = HtmlUnescape();
    return Padding(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Card(
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7), color: Colors.white),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  _launchURL(url!);
                },
                child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(7),
                      topRight: Radius.circular(7),
                    ),
                    child: urlToImage!.isNotEmpty
                        ? CachedNetworkImage(
                            fit: BoxFit.fitHeight,
                            errorWidget: (context, url, error) => Container(
                              height: 150.0,
                              child: const Center(
                                child:
                                    Icon(Icons.link_off, color: Colors.white60),
                              ),
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(7),
                                  topRight: Radius.circular(7),
                                ),
                              ),
                            ),
                            placeholder: (context, url) => Container(
                              height: 150.0,
                              child: const Center(
                                  child: CircularProgressIndicator()),
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(7),
                                  topRight: Radius.circular(7),
                                ),
                              ),
                            ),
                            imageUrl: urlToImage!,
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
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(7),
                                  topRight: Radius.circular(7),
                                ),
                              ),
                            ),
                          )),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
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
                    Text(unescape.convert(description!),
                        style: kCaption12TextStyle),
                    const SizedBox(
                      height: 10,
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Flexible(
                                    fit: FlexFit.loose,
                                    child: Text(name!,
                                        softWrap: false,
                                        overflow: TextOverflow.fade),
                                  ),
                                  Flexible(
                                    fit: FlexFit.loose,
                                    child: Text('  \u2022  $publishedAt',
                                        softWrap: false,
                                        overflow: TextOverflow.fade),
                                  ),
                                ],
                              ),
                              Text(author!, overflow: TextOverflow.ellipsis),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Share.share('$title\n\n$url', subject: title);
                          },
                          child: const Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: Icon(
                              Icons.share,
                              size: 25,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
