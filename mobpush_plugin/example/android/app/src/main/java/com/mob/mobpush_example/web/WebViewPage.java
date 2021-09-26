package com.mob.mobpush_example.web;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.drawable.ColorDrawable;
import android.net.Uri;
import android.net.http.SslError;
import android.util.TypedValue;
import android.view.Gravity;
import android.view.KeyEvent;
import android.view.View;
import android.view.Window;
import android.webkit.SslErrorHandler;
import android.webkit.WebChromeClient;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.LinearLayout.LayoutParams;
import android.widget.ProgressBar;
import android.widget.TextView;

import com.mob.mobpush_example.utils.SizeHelper;
import com.mob.tools.FakeActivity;
import com.mob.tools.utils.ResHelper;

/**
 * Created by yychen on 2017/11/2.
 */

public class WebViewPage extends FakeActivity {
	private LinearLayout mainlayout;
	private ImageView ivBack;
	private TextView tvTitle;
	private ProgressBar progressBar;
	private BaseWebView webView;
	private String url;

	@Override
	public void onCreate() {
		Window window = activity.getWindow();
		window.setBackgroundDrawable(new ColorDrawable(0xFFFFFFFF));
		initPage(activity);
		activity.setContentView(mainlayout);
	}

	public void setJumpUrl(String url) {
		this.url = url;
	}

	private void initPage(final Activity activity) {
		initView();

		webView.setWebViewClient(new WebViewClient() {
			private String startUrl;

			@Override
			public void onPageStarted(WebView view, String url, Bitmap favicon) {
				super.onPageStarted(view, url, favicon);
				startUrl = url;
			}

			public void onReceivedSslError(WebView view, SslErrorHandler handler, SslError error) {
				handler.proceed();
			}

			@Override
			public boolean shouldOverrideUrlLoading(WebView view, String url1) {
				if (url1 == null) return false;
				try {
					if (!url1.startsWith("http://") && !url1.startsWith("https://")) {
						Intent intent = new Intent(Intent.ACTION_VIEW, Uri.parse(url1));
						startActivity(intent);
						return false;
					}
				} catch (Exception e) {
//					//防止crash (如果手机上没有安装处理某个scheme开头的url的APP, 会导致crash)
					return true;//没有安装该app时，返回true，表示拦截自定义链接，但不跳转，避免弹出上面的错误页面
				}

				//返回值是true的时候控制去WebView打开，为false调用系统浏览器或第三方浏览器
				if (startUrl != null && startUrl.equals(url)) {
					view.loadUrl(url);
				} else {
//交给系统处理
					return super.shouldOverrideUrlLoading(view, url);
				}
				return true;
			}

			public void onPageFinished(WebView view, String url) {
				super.onPageFinished(view, url);
				if (view != null) {
					tvTitle.setText(view.getTitle());
				}
			}
		});
		webView.setWebChromeClient(new WebChromeClient() {
			public void onProgressChanged(WebView view, int newProgress) {
				progressBar.setProgress(newProgress);
				if (newProgress == 100) {
					progressBar.setVisibility(View.GONE);
				} else if (progressBar.getVisibility() == View.GONE) {
					progressBar.setVisibility(View.VISIBLE);
				}
				super.onProgressChanged(view, newProgress);
			}
		});

		webView.loadUrl(url);
		ivBack.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View view) {
				if (webView != null && webView.canGoBack()) {
					webView.goBack();
				} else {
					finishOnSuccess();
				}
			}
		});
	}

	@SuppressLint("WrongConstant")
	private void initView() {
		SizeHelper.prepare(getContext());
		int px2 = SizeHelper.fromPxWidth(2);
		int px3 = SizeHelper.fromPxWidth(3);
		int px15 = SizeHelper.fromPxWidth(15);
		int px30 = SizeHelper.fromPxWidth(30);

		mainlayout = new LinearLayout(getContext());
		mainlayout.setOrientation(LinearLayout.VERTICAL);
		LayoutParams lp = new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT);

		LinearLayout titlelayout = new LinearLayout(getContext());
		titlelayout.setPadding(px15, 0, px15, 0);
		lp = new LayoutParams(LayoutParams.MATCH_PARENT, 0, 1);
		mainlayout.addView(titlelayout, lp);

		ivBack = new ImageView(getContext());
		ivBack.setScaleType(ImageView.ScaleType.CENTER_CROP);
		ivBack.setImageResource(ResHelper.getBitmapRes(getContext(), "ic_back"));
		lp = new LayoutParams(px30, px30);
		lp.gravity = Gravity.LEFT | Gravity.CENTER_VERTICAL;
		titlelayout.addView(ivBack, lp);

		tvTitle = new TextView(getContext());
		tvTitle.setGravity(Gravity.CENTER);
		tvTitle.setMaxLines(1);
		tvTitle.setTextSize(TypedValue.COMPLEX_UNIT_PX, SizeHelper.fromPxWidth(22));
		tvTitle.setTextColor(0xff1e1e1e);
		lp = new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT);
		lp.gravity = Gravity.CENTER_VERTICAL;
		lp.leftMargin = px15;
		titlelayout.addView(tvTitle, lp);

		//分割线
		View line = new View(getContext());
		line.setBackgroundColor(0xffe8e8e8);
		lp = new LayoutParams(LayoutParams.MATCH_PARENT, px2);
		mainlayout.addView(line, lp);

		progressBar = new ProgressBar(getContext(), null, android.R.style.Widget_ProgressBar_Horizontal);
		progressBar.setMax(100);
		progressBar.setIndeterminate(false);
		lp = new LayoutParams(LayoutParams.MATCH_PARENT, px3);
		mainlayout.addView(progressBar, lp);
		progressBar.setProgressDrawable(activity.getResources().getDrawable(ResHelper.getBitmapRes(getContext(), "webview_progressbar_bg")));

		webView = new BaseWebView(getContext());
		lp = new LayoutParams(LayoutParams.MATCH_PARENT, 0, 11);
		mainlayout.addView(webView, lp);
	}

	public boolean onKeyEvent(int keyCode, KeyEvent event) {
		if (keyCode == KeyEvent.KEYCODE_BACK && event.getAction() == KeyEvent.ACTION_UP) {
			if (webView != null && webView.canGoBack()) {
				webView.goBack();
			} else {
				finishOnSuccess();
			}
			return true;
		}
		return super.onKeyEvent(keyCode, event);
	}

	public void finishOnSuccess() {
		finish();
	}
}
